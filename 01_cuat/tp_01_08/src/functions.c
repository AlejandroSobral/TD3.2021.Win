#include "../inc/functions.h"

        //asm("xchg %bx, %bx"); asm input exmpl
__attribute__(( section(".functions"))) byte __fast_memcpy(bits32_v*src,bits32_v *dst,bits32_v length)
{
    byte status = ERROR_CODE;

    if(length>0)
    {
        while(length)
        {
            length--;
            *dst++=*src++;
        }
        status = OK_CODE;
    }
     return (status);
}

__attribute__(( section(".functions"))) byte IDT_handler_loader(bits32_v *exception_num,
                                                             bits32_v *cs, 
                                                             bits32_v *handler,
                                                             bits32_v *attr, 
                                                             bits32_v *idt_dir){ 
    byte i;
    for (i = 0; i < (2 * (bits32_v)exception_num) ; i++){
        *idt_dir++;
    }

    bits32_v high = (((bits32_v)cs)<<0x10);
    bits32_v low = (0x0000FFFF&(bits32_v)handler);

    *idt_dir = high|low;
    *idt_dir++;

    high = (0xFFFF0000&(bits32_v)handler);
    //low = 0x00008E00;
    low = (0xFFFF & ((bits32_v)attr)<<0x8);

    *idt_dir = high|low;
    
    return 1;
}



                                                                

__attribute__(( section(".functions"))) void Screen_Writing(Video_Buffer* Video_Buff_v, _64bits_average* avrg_p, bits16_v row, bits16_v column)
{	bits16_v offset = 0;
	bits64_v aux = 0;
	bits32_v aux_L = 0;
	bits32_v aux_H = 0;
	byte Aux_var = 0;
	byte string[] = "Alejandro Sobral - UTN FRBA - TDIII - 2021.";
    byte nmbr[16];
	bits16_v length = 0;
	length = sizeof(string);

	aux = avrg_p->avrg;
	aux_L = avrg_p->avrg;
	aux_H = (avrg_p->avrg) >> 32;
	for(offset = 0; offset < Keyb_buffer_size; offset++)
	{
		if(offset < Keyb_buffer_size/2)
		{
			Aux_var = aux_L % 16; // From DEC to HEX
			aux_L = aux_L / 16;
			if(Aux_var>=10)
    		{
    			Aux_var=Aux_var+7;
    		}
			nmbr[offset] = Aux_var;
		}
		else
		{	
			Aux_var = aux_H % 16; // From DEC to HEX			
			aux_H = aux_H / 16;	
			if(Aux_var>=10)
    		{
    			Aux_var=Aux_var+ASCII_OFFSET_LETTERNUMBER; //ASCII offset between letters and numbers
    		}
			nmbr[offset] = Aux_var;	
		}
	}

	if((row < 25) & (column < 80))
	{
		for(offset = 0; offset < Keyb_buffer_size; offset++)
		{
			Video_Buff_v->buffer[((column + offset) * 2) + (row * 160)] = 48 + nmbr[Keyb_buffer_size-1 - offset];	///Set Data & data offset
			Video_Buff_v->buffer[((column + offset) * 2 + 1) + (row * 160)] = 0x07;	///Set attrb.
		}
	}
	for(offset = 0; offset < length; offset++)
	{
		Video_Buff_v->buffer[((0 + offset) * 2) + (24 * 160)] = string[offset];	//Set Data
		Video_Buff_v->buffer[((0 + offset) * 2 + 1) + (24 * 160)] = 0x07;	//Set attrb.
    }        
}




__attribute__((section(".functions"))) void __load_DTP_entry(bits32_v init_dpt,
														bits32_v VMA,
                                                        byte _ps,
                                                        byte _a,
                                                        byte _pcd,
                                                        byte _pwt,
                                                        byte _us,
                                                        byte _rw,
                                                        byte _p)
{
	bits32_v entry_dtp = 0x00;
	bits32_v init_pt = 0x00;
	bits32_v dpte = 0;

	entry_dtp = Get_Entry_DTP (VMA); //Get DTP Entry Index from VMA Addr
	init_pt = (init_dpt + 0x1000 )+ (0x1000*entry_dtp); // Set Init PT from DTP BASE + DTP SIZE + DEFAULT_SIZE*INDEX
    bits32_v *dst = (bits32_v *)init_dpt;
    dpte |= (init_pt & 0xFFFFF000);
    dpte |= (_ps << 7);
    dpte |= (_a << 5);
    dpte |= (_pcd << 4);
    dpte |= (_pwt << 3);
    dpte |= (_us << 2);
    dpte |= (_rw << 1);
    dpte |= (_p << 0);

	

    *(dst + entry_dtp) = dpte;
}

__attribute__((section(".functions"))) bits32_v Get_Entry_DTP(bits32_v init_dpt) //Get DTP from VMA
{
	bits32_v DTP = 0x00;

	DTP = (init_dpt >> 22) & 0x03FF ;//31-22 bits

	return DTP;

}

__attribute__((section(".functions"))) void __load_TP_entry(bits32_v init_pt,
                                                       bits32_v VMA,
                                                       byte _g,
                                                       byte _pat,
                                                       byte _d,
                                                       byte _a,
                                                       byte _pcd,
                                                       byte _pwt,
                                                       byte _us,
                                                       byte _rw,
                                                       byte _p)
{
	
	bits32_v entry_tp = 0x0, entry_dtp = 0x0;
    bits32_v pte = 0;


	entry_dtp = Get_Entry_DTP (VMA); //Get DTP Entry Index from VMA Addr
	entry_tp = Get_Entry_TP(VMA);
	init_pt = (init_pt)+(0x1000*entry_dtp); // Set Init PT from DTP BASE + DTP SIZE + DEFAULT_SIZE*INDEX

    bits32_v *dst = (bits32_v *)init_pt;


    pte |= (VMA & 0xFFFFF000);
    pte |= (_g << 8);
    pte |= (_pat << 7);
    pte |= (_d << 6);
    pte |= (_a << 5);
    pte |= (_pcd << 4);
    pte |= (_pwt << 3);
    pte |= (_us << 2);
    pte |= (_rw << 1);
    pte |= (_p << 0);
    *(dst + entry_tp) = pte;


}

	__attribute__((section(".functions"))) bits32_v Get_Entry_TP(bits32_v init_dpt)  //Get PTE from VMA
{
	bits32_v PTE = 0x00;

	PTE = (init_dpt >> 12) & 0x3FF ;//21-12 bits


	return PTE;

}

__attribute__(( section(".functions")))bits32_v LOAD_CR3 (bits32_v init_dpt, byte _pcd, byte _pwt)
{
    bits32_v cr3 = 0;

    cr3 |= (init_dpt & 0xFFFFF000);
    cr3 |= (_pcd << 4);
    cr3 |= (_pwt << 3);

    return cr3;

}