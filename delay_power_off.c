#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/syscore_ops.h>
#include <linux/delay.h>

MODULE_LICENSE("GPL" );
MODULE_AUTHOR("Markus Schaaf <markuschaaf@gmail.com>");
MODULE_DESCRIPTION("Delays power-off and restart, allowing proper shutdown of devices.");
MODULE_VERSION("1.0");

static unsigned delay_ms = 2000;
module_param(delay_ms, uint, 0644);
MODULE_PARM_DESC(delay_ms, "delay before shutdown in milliseconds (default: 2000)");

static void dpo_shutdown(void)
{
	mdelay(delay_ms);
}

static struct syscore_ops dpo_syscore_ops = {
	.shutdown = dpo_shutdown
};

int init_module(void)
{
	register_syscore_ops(&dpo_syscore_ops);
	printk(KERN_INFO "delay_power_off: %ums\n", delay_ms);
	return 0;
}

void cleanup_module(void)
{
	unregister_syscore_ops(&dpo_syscore_ops);
	printk(KERN_INFO "delay_power_off: removed\n");
}
