/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_2592010699;
char *STD_STANDARD;
char *IEEE_P_3620187407;
char *IEEE_P_3499444699;
char *UNISIM_P_0947159679;
char *IEEE_P_3564397177;
char *STD_TEXTIO;
char *IEEE_P_1242562249;
char *IEEE_P_0774719531;
char *IEEE_P_2717149903;
char *IEEE_P_1367372525;
char *UNISIM_P_3222816464;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_1242562249_init();
    unisim_p_0947159679_init();
    std_textio_init();
    ieee_p_3564397177_init();
    ieee_p_3499444699_init();
    ieee_p_0774719531_init();
    ieee_p_2717149903_init();
    ieee_p_1367372525_init();
    unisim_p_3222816464_init();
    unisim_a_1490675510_1976025627_init();
    unisim_a_4050236036_2930107152_init();
    unisim_a_2648394979_1532504268_init();
    unisim_a_0600400571_2930107152_init();
    unisim_a_1182629975_1532504268_init();
    unisim_a_3935320881_1820106778_init();
    work_a_4015317117_3212880686_init();
    ieee_p_3620187407_init();
    work_a_3878943448_3212880686_init();
    work_a_0172039124_3212880686_init();
    work_a_2078045128_3212880686_init();
    unisim_a_2377850934_0093012374_init();
    unisim_a_3046784456_0093012374_init();
    work_a_0534478308_3212880686_init();
    work_a_1346024049_3212880686_init();
    unisim_a_1478392591_3979135294_init();
    work_a_0081900637_3212880686_init();
    work_a_0746414571_3212880686_init();
    work_a_0518314390_3212880686_init();
    work_a_3764410338_3212880686_init();
    work_a_0330488113_3212880686_init();
    work_a_1627427427_3212880686_init();
    work_a_0118922258_2372691052_init();


    xsi_register_tops("work_a_0118922258_2372691052");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    UNISIM_P_0947159679 = xsi_get_engine_memory("unisim_p_0947159679");
    IEEE_P_3564397177 = xsi_get_engine_memory("ieee_p_3564397177");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    IEEE_P_0774719531 = xsi_get_engine_memory("ieee_p_0774719531");
    IEEE_P_2717149903 = xsi_get_engine_memory("ieee_p_2717149903");
    IEEE_P_1367372525 = xsi_get_engine_memory("ieee_p_1367372525");
    UNISIM_P_3222816464 = xsi_get_engine_memory("unisim_p_3222816464");

    return xsi_run_simulation(argc, argv);

}
