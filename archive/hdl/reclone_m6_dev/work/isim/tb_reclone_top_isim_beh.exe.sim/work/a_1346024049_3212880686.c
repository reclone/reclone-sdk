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
static const char *ng0 = "C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/hdl/reclone_m6_dev/DvidSer.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_1346024049_3212880686_p_0(char *t0)
{
    char t6[16];
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    unsigned char t5;
    char *t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;

LAB0:    xsi_set_current_line(107, ng0);

LAB3:    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 2312U);
    t4 = *((char **)t1);
    t5 = *((unsigned char *)t4);
    t7 = ((IEEE_P_2592010699) + 4024);
    t1 = xsi_base_array_concat(t1, t6, t7, (char)99, t3, (char)99, t5, (char)101);
    t8 = (1U + 1U);
    t9 = (2U != t8);
    if (t9 == 1)
        goto LAB5;

LAB6:    t10 = (t0 + 8480);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t1, 2U);
    xsi_driver_first_trans_fast(t10);

LAB2:    t15 = (t0 + 8368);
    *((int *)t15) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(2U, t8, 0);
    goto LAB6;

}

static void work_a_1346024049_3212880686_p_1(char *t0)
{
    char t4[16];
    char t10[16];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    unsigned char t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;

LAB0:    xsi_set_current_line(113, ng0);

LAB3:    t1 = (t0 + 3272U);
    t2 = *((char **)t1);
    t1 = (t0 + 3432U);
    t3 = *((char **)t1);
    t5 = ((IEEE_P_2592010699) + 4024);
    t6 = (t0 + 15984U);
    t7 = (t0 + 15984U);
    t1 = xsi_base_array_concat(t1, t4, t5, (char)97, t2, t6, (char)97, t3, t7, (char)101);
    t8 = (t0 + 3592U);
    t9 = *((char **)t8);
    t11 = ((IEEE_P_2592010699) + 4024);
    t12 = (t0 + 15984U);
    t8 = xsi_base_array_concat(t8, t10, t11, (char)97, t1, t4, (char)97, t9, t12, (char)101);
    t13 = (10U + 10U);
    t14 = (t13 + 10U);
    t15 = (30U != t14);
    if (t15 == 1)
        goto LAB5;

LAB6:    t16 = (t0 + 8544);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t8, 30U);
    xsi_driver_first_trans_fast(t16);

LAB2:    t21 = (t0 + 8384);
    *((int *)t21) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(30U, t14, 0);
    goto LAB6;

}

static void work_a_1346024049_3212880686_p_2(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    unsigned char t8;
    unsigned char t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(139, ng0);
    t1 = (t0 + 1152U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 8400);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(140, ng0);
    t3 = (t0 + 5352U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)2);
    if (t6 != 0)
        goto LAB5;

LAB7:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(141, ng0);
    t3 = (t0 + 5192U);
    t7 = *((char **)t3);
    t8 = *((unsigned char *)t7);
    t9 = (t8 == (unsigned char)3);
    if (t9 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(148, ng0);
    t1 = (t0 + 5032U);
    t3 = *((char **)t1);
    t11 = (29 - 24);
    t12 = (t11 * 1U);
    t13 = (0 + t12);
    t1 = (t3 + t13);
    t4 = (t0 + 8608);
    t7 = (t4 + 56U);
    t10 = *((char **)t7);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t1, 5U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(149, ng0);
    t1 = (t0 + 5032U);
    t3 = *((char **)t1);
    t11 = (29 - 14);
    t12 = (t11 * 1U);
    t13 = (0 + t12);
    t1 = (t3 + t13);
    t4 = (t0 + 8672);
    t7 = (t4 + 56U);
    t10 = *((char **)t7);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t1, 5U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(150, ng0);
    t1 = (t0 + 5032U);
    t3 = *((char **)t1);
    t11 = (29 - 4);
    t12 = (t11 * 1U);
    t13 = (0 + t12);
    t1 = (t3 + t13);
    t4 = (t0 + 8736);
    t7 = (t4 + 56U);
    t10 = *((char **)t7);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t1, 5U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(151, ng0);
    t1 = (t0 + 16342);
    t4 = (t0 + 8800);
    t7 = (t4 + 56U);
    t10 = *((char **)t7);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t1, 5U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(152, ng0);
    t1 = (t0 + 8864);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t10 = *((char **)t7);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);

LAB9:    goto LAB6;

LAB8:    xsi_set_current_line(142, ng0);
    t3 = (t0 + 5032U);
    t10 = *((char **)t3);
    t11 = (29 - 29);
    t12 = (t11 * 1U);
    t13 = (0 + t12);
    t3 = (t10 + t13);
    t14 = (t0 + 8608);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t3, 5U);
    xsi_driver_first_trans_fast(t14);
    xsi_set_current_line(143, ng0);
    t1 = (t0 + 5032U);
    t3 = *((char **)t1);
    t11 = (29 - 19);
    t12 = (t11 * 1U);
    t13 = (0 + t12);
    t1 = (t3 + t13);
    t4 = (t0 + 8672);
    t7 = (t4 + 56U);
    t10 = *((char **)t7);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t1, 5U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(144, ng0);
    t1 = (t0 + 5032U);
    t3 = *((char **)t1);
    t11 = (29 - 9);
    t12 = (t11 * 1U);
    t13 = (0 + t12);
    t1 = (t3 + t13);
    t4 = (t0 + 8736);
    t7 = (t4 + 56U);
    t10 = *((char **)t7);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t1, 5U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(145, ng0);
    t1 = (t0 + 16337);
    t4 = (t0 + 8800);
    t7 = (t4 + 56U);
    t10 = *((char **)t7);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t1, 5U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(146, ng0);
    t1 = (t0 + 8864);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t10 = *((char **)t7);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    goto LAB9;

}


extern void work_a_1346024049_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1346024049_3212880686_p_0,(void *)work_a_1346024049_3212880686_p_1,(void *)work_a_1346024049_3212880686_p_2};
	xsi_register_didat("work_a_1346024049_3212880686", "isim/tb_reclone_top_isim_beh.exe.sim/work/a_1346024049_3212880686.didat");
	xsi_register_executes(pe);
}
