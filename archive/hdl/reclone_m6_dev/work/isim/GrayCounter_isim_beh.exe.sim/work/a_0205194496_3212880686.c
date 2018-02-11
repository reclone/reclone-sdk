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

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/hdl/reclone_m6_dev/GrayCounter.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

char *ieee_p_2592010699_sub_1697423399_503743352(char *, char *, char *, char *, char *, char *);
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );
char *ieee_p_3620187407_sub_436279890_3965413181(char *, char *, char *, char *, int );


static void work_a_0205194496_3212880686_p_0(char *t0)
{
    char t13[16];
    char t24[16];
    char t30[16];
    char t33[16];
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    int t17;
    int t18;
    unsigned int t19;
    int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    int t25;
    unsigned int t26;
    int t27;
    unsigned int t28;
    unsigned int t29;
    int t31;
    unsigned int t32;
    char *t34;
    char *t35;
    unsigned int t36;
    unsigned int t37;
    char *t38;
    char *t39;
    char *t40;
    char *t41;
    char *t42;

LAB0:    xsi_set_current_line(43, ng0);
    t1 = (t0 + 1312U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 3272);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(44, ng0);
    t3 = (t0 + 1192U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:    t1 = (t0 + 1032U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)3);
    if (t5 != 0)
        goto LAB8;

LAB9:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(45, ng0);
    t3 = xsi_get_transient_memory(4U);
    memset(t3, 0, 4U);
    t7 = t3;
    memset(t7, (unsigned char)2, 4U);
    t8 = (t0 + 3352);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t3, 4U);
    xsi_driver_first_trans_fast(t8);
    xsi_set_current_line(46, ng0);
    t1 = xsi_get_transient_memory(4U);
    memset(t1, 0, 4U);
    t3 = t1;
    memset(t3, (unsigned char)2, 4U);
    t4 = (t0 + 3416);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 4U);
    xsi_driver_first_trans_fast_port(t4);
    goto LAB6;

LAB8:    xsi_set_current_line(48, ng0);
    t1 = (t0 + 1672U);
    t4 = *((char **)t1);
    t1 = (t0 + 5664U);
    t7 = ieee_p_3620187407_sub_436279890_3965413181(IEEE_P_3620187407, t13, t4, t1, 1);
    t8 = (t13 + 12U);
    t14 = *((unsigned int *)t8);
    t15 = (1U * t14);
    t6 = (4U != t15);
    if (t6 == 1)
        goto LAB10;

LAB11:    t9 = (t0 + 3352);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t16 = *((char **)t12);
    memcpy(t16, t7, 4U);
    xsi_driver_first_trans_fast(t9);
    xsi_set_current_line(49, ng0);
    t1 = (t0 + 1672U);
    t3 = *((char **)t1);
    t17 = (4 - 1);
    t18 = (t17 - 3);
    t14 = (t18 * -1);
    t15 = (1U * t14);
    t19 = (0 + t15);
    t1 = (t3 + t19);
    t2 = *((unsigned char *)t1);
    t4 = (t0 + 1672U);
    t7 = *((char **)t4);
    t20 = (4 - 2);
    t21 = (3 - t20);
    t22 = (t21 * 1U);
    t23 = (0 + t22);
    t4 = (t7 + t23);
    t8 = (t24 + 0U);
    t9 = (t8 + 0U);
    *((int *)t9) = 2;
    t9 = (t8 + 4U);
    *((int *)t9) = 0;
    t9 = (t8 + 8U);
    *((int *)t9) = -1;
    t25 = (0 - 2);
    t26 = (t25 * -1);
    t26 = (t26 + 1);
    t9 = (t8 + 12U);
    *((unsigned int *)t9) = t26;
    t9 = (t0 + 1672U);
    t10 = *((char **)t9);
    t27 = (4 - 1);
    t26 = (3 - t27);
    t28 = (t26 * 1U);
    t29 = (0 + t28);
    t9 = (t10 + t29);
    t11 = (t30 + 0U);
    t12 = (t11 + 0U);
    *((int *)t12) = 3;
    t12 = (t11 + 4U);
    *((int *)t12) = 1;
    t12 = (t11 + 8U);
    *((int *)t12) = -1;
    t31 = (1 - 3);
    t32 = (t31 * -1);
    t32 = (t32 + 1);
    t12 = (t11 + 12U);
    *((unsigned int *)t12) = t32;
    t12 = ieee_p_2592010699_sub_1697423399_503743352(IEEE_P_2592010699, t13, t4, t24, t9, t30);
    t34 = ((IEEE_P_2592010699) + 4024);
    t16 = xsi_base_array_concat(t16, t33, t34, (char)99, t2, (char)97, t12, t13, (char)101);
    t35 = (t13 + 12U);
    t32 = *((unsigned int *)t35);
    t36 = (1U * t32);
    t37 = (1U + t36);
    t5 = (4U != t37);
    if (t5 == 1)
        goto LAB12;

LAB13:    t38 = (t0 + 3416);
    t39 = (t38 + 56U);
    t40 = *((char **)t39);
    t41 = (t40 + 56U);
    t42 = *((char **)t41);
    memcpy(t42, t16, 4U);
    xsi_driver_first_trans_fast_port(t38);
    goto LAB6;

LAB10:    xsi_size_not_matching(4U, t15, 0);
    goto LAB11;

LAB12:    xsi_size_not_matching(4U, t37, 0);
    goto LAB13;

}


extern void work_a_0205194496_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0205194496_3212880686_p_0};
	xsi_register_didat("work_a_0205194496_3212880686", "isim/GrayCounter_isim_beh.exe.sim/work/a_0205194496_3212880686.didat");
	xsi_register_executes(pe);
}
