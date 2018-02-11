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
static const char *ng0 = "C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/hdl/reclone_m6_dev/reclone_top.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_1242562249;

char *ieee_p_1242562249_sub_1919365254_1035706684(char *, char *, char *, char *, int );
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_1627427427_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(182, ng0);

LAB3:    t1 = (t0 + 7592U);
    t2 = *((char **)t1);
    t1 = (t0 + 10920);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 5U);
    xsi_driver_first_trans_delta(t1, 3U, 5U, 0LL);

LAB2:    t7 = (t0 + 10792);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1627427427_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;

LAB0:    xsi_set_current_line(183, ng0);

LAB3:    t1 = (t0 + 10984);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)2;
    xsi_driver_first_trans_delta(t1, 2U, 1, 0LL);

LAB2:
LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1627427427_3212880686_p_2(char *t0)
{
    char t3[16];
    char *t1;
    unsigned char t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    int t16;
    int t17;
    unsigned int t18;

LAB0:    xsi_set_current_line(186, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 10808);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(187, ng0);
    t4 = (t0 + 3112U);
    t5 = *((char **)t4);
    t4 = (t0 + 19784U);
    t6 = ieee_p_1242562249_sub_1919365254_1035706684(IEEE_P_1242562249, t3, t5, t4, 1);
    t7 = (t3 + 12U);
    t8 = *((unsigned int *)t7);
    t9 = (1U * t8);
    t10 = (26U != t9);
    if (t10 == 1)
        goto LAB5;

LAB6:    t11 = (t0 + 11048);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t6, 26U);
    xsi_driver_first_trans_fast(t11);
    xsi_set_current_line(188, ng0);
    t1 = (t0 + 3112U);
    t4 = *((char **)t1);
    if (25 > 0)
        goto LAB7;

LAB8:    if (-1 == -1)
        goto LAB12;

LAB13:    t16 = 0;

LAB9:    t17 = (t16 - 25);
    t8 = (t17 * -1);
    t9 = (1U * t8);
    t18 = (0 + t9);
    t1 = (t4 + t18);
    t2 = *((unsigned char *)t1);
    t5 = (t0 + 11112);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t11 = (t7 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t2;
    xsi_driver_first_trans_delta(t5, 1U, 1, 0LL);
    goto LAB3;

LAB5:    xsi_size_not_matching(26U, t9, 0);
    goto LAB6;

LAB7:    if (-1 == 1)
        goto LAB10;

LAB11:    t16 = 25;
    goto LAB9;

LAB10:    t16 = 0;
    goto LAB9;

LAB12:    t16 = 25;
    goto LAB9;

}

static void work_a_1627427427_3212880686_p_3(char *t0)
{
    char t3[16];
    char *t1;
    unsigned char t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    int t16;
    int t17;
    unsigned int t18;

LAB0:    xsi_set_current_line(193, ng0);
    t1 = (t0 + 3392U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 10824);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(194, ng0);
    t4 = (t0 + 3272U);
    t5 = *((char **)t4);
    t4 = (t0 + 19800U);
    t6 = ieee_p_1242562249_sub_1919365254_1035706684(IEEE_P_1242562249, t3, t5, t4, 1);
    t7 = (t3 + 12U);
    t8 = *((unsigned int *)t7);
    t9 = (1U * t8);
    t10 = (26U != t9);
    if (t10 == 1)
        goto LAB5;

LAB6:    t11 = (t0 + 11176);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t6, 26U);
    xsi_driver_first_trans_fast(t11);
    xsi_set_current_line(195, ng0);
    t1 = (t0 + 3272U);
    t4 = *((char **)t1);
    if (25 > 0)
        goto LAB7;

LAB8:    if (-1 == -1)
        goto LAB12;

LAB13:    t16 = 0;

LAB9:    t17 = (t16 - 25);
    t8 = (t17 * -1);
    t9 = (1U * t8);
    t18 = (0 + t9);
    t1 = (t4 + t18);
    t2 = *((unsigned char *)t1);
    t5 = (t0 + 11240);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t11 = (t7 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t2;
    xsi_driver_first_trans_delta(t5, 0U, 1, 0LL);
    goto LAB3;

LAB5:    xsi_size_not_matching(26U, t9, 0);
    goto LAB6;

LAB7:    if (-1 == 1)
        goto LAB10;

LAB11:    t16 = 25;
    goto LAB9;

LAB10:    t16 = 0;
    goto LAB9;

LAB12:    t16 = 25;
    goto LAB9;

}

static void work_a_1627427427_3212880686_p_4(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;

LAB0:    xsi_set_current_line(269, ng0);

LAB3:    t1 = (t0 + 11304);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)2;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);

LAB2:
LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1627427427_3212880686_p_5(char *t0)
{
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned int t4;
    unsigned int t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;

LAB0:    xsi_set_current_line(270, ng0);

LAB3:    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t3 = (22 - 22);
    t4 = (t3 * 1U);
    t5 = (0 + t4);
    t1 = (t2 + t5);
    t6 = (t0 + 11368);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 7U);
    xsi_driver_first_trans_delta(t6, 1U, 7U, 0LL);

LAB2:    t11 = (t0 + 10840);
    *((int *)t11) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_1627427427_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1627427427_3212880686_p_0,(void *)work_a_1627427427_3212880686_p_1,(void *)work_a_1627427427_3212880686_p_2,(void *)work_a_1627427427_3212880686_p_3,(void *)work_a_1627427427_3212880686_p_4,(void *)work_a_1627427427_3212880686_p_5};
	xsi_register_didat("work_a_1627427427_3212880686", "isim/tb_reclone_top_isim_beh.exe.sim/work/a_1627427427_3212880686.didat");
	xsi_register_executes(pe);
}
