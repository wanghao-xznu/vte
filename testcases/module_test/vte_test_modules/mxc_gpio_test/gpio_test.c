/*
 * Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */
#include <linux/module.h>
#include <linux/init.h>
#include <linux/list.h>
#include <linux/types.h>
#include <linux/kernel.h> 
#include <linux/interrupt.h>
#include <linux/moduleparam.h>
#include <linux/io.h>
#include <linux/slab.h>
#include <linux/vmalloc.h>
#include <linux/sched.h>
#include <linux/gpio.h>
#include <asm/atomic.h>
#include <mach/hardware.h>

#define MX6_ARM2_DISP0_RESET IMX_GPIO_NR(5, 0)
#define SABRESD_DISP0_RST_B IMX_GPIO_NR(3, 8)
#define  GPIO_PSR 8
#define  GPIO_DR 0

static unsigned test_count = 10000;
module_param(test_count,uint,0);
MODULE_PARM_DESC(test_count,"tested size of memory");

static struct timeval start, finish;

static long calc_time(unsigned long size)
{
	unsigned long us, speed;
	us = (finish.tv_sec - start.tv_sec) * 1000 * 1000 +
	     (finish.tv_usec - start.tv_usec);
	printk("totle time is %ldus\n", us);
	speed = us / size;
	return speed;
}


static int test_init(void)
{
	int count = test_count;
	unsigned long speed = 0;
	/*map GPIO3*/
	void __iomem *reg = ioremap(GPIO3_BASE_ADDR,SZ_32K); 
	u32 l;

	printk(KERN_INFO "gpio test on disp0-reset\n");
	/*test memory io*/
	gpio_request(SABRESD_DISP0_RST_B, "disp0-reset");
	do_gettimeofday(&start);
	while(count--){
		gpio_direction_output(SABRESD_DISP0_RST_B, 0);
	}
	do_gettimeofday(&finish);
	speed = calc_time(test_count);
	printk(KERN_INFO "gpio set speed is %ld us\n", speed);
	count = test_count;
	do_gettimeofday(&start);
	l = (__raw_readl(reg + GPIO_DR) & (~(1 << 8))) | (!!1 << 8);
	while(count--){
		__raw_writel(l ,reg + GPIO_DR);
	}
	do_gettimeofday(&finish);
	speed = calc_time(test_count);
	printk(KERN_INFO "gpio set speed is %ld us\n", speed);
	return -ENODEV;
}

static void test_exit(void)
{
    return;     
}

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Freescale Semiconductor, Inc.");
module_init(test_init);
module_exit(test_exit);