#include "internal.h"
#include <linux/init.h>
#include <linux/module.h>
#include <linux/printk.h>
#include <linux/kprobes.h>

#define MAX_KPROBE_ENTRY 8
static struct kprobe kprobes[MAX_KPROBE_ENTRY];
static int nr_kprobes;

static int __kprobes kp_pre_handler_trace(struct kprobe *kp,
		struct pt_regs *regs)
{
	pr_info("kp_pre: \"%s\" called\n", kp->symbol_name);
	return 0;
}

static void __kprobes kp_post_handler_trace(struct kprobe *kp,
		struct pt_regs *regs, unsigned long flags)
{
	pr_info("kp_post: \"%s\" called\n", kp->symbol_name);
}

static int register_kprobe_by_symbol_name(char *symbol_name)
{
	int ret;
	int idx = nr_kprobes;
	struct kprobe *kp;

	if (idx == MAX_KPROBE_ENTRY) {
		pr_err("Registration limit reached (Max number of entries: %d)\n", MAX_KPROBE_ENTRY);
		return -ENOBUFS;
	} else if (idx > MAX_KPROBE_ENTRY) {
		pr_err("unexpected number of probes: %d (MAX: %d)\n", idx, MAX_KPROBE_ENTRY);
		return -ENOBUFS;
	}

	kp = &kprobes[idx];
	kp->symbol_name = symbol_name;
	kp->pre_handler = kp_pre_handler_trace;
	kp->post_handler = kp_post_handler_trace;

	ret = register_kprobe(kp);
	if (ret < 0) {
		pr_err("failed to register probe of \"%s\"\n", symbol_name);
		return ret;
	}

	pr_info("register probe of \"%s\"\n", symbol_name);

	nr_kprobes++;

	return 0;
}

static void unregister_all_kprobes(void)
{
	for (int i = 0; i < nr_kprobes; i++)
		unregister_kprobe(&kprobes[i]);
}

static int __init probe_init(void)
{
	char *probed_symbols[] = {
		"__x64_sys_reboot",
	};
	int nr_syms = sizeof(probed_symbols) / sizeof (char *);

	for (int i = 0; i < nr_syms; i++)
		register_kprobe_by_symbol_name(probed_symbols[i]);

	return 0;
}

static void __exit probe_exit(void)
{
	unregister_all_kprobes();
}


module_init(probe_init);
module_exit(probe_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("hogedamari");
MODULE_DESCRIPTION("Probe kernel internals");
