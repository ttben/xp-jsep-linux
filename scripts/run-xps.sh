#!/bin/bash

patches_list=(scripts/coccinelle/misc/cond_no_effect.cocci scripts/coccinelle/misc/of_table.cocci scripts/coccinelle/misc/boolreturn.cocci scripts/coccinelle/misc/warn.cocci scripts/coccinelle/misc/noderef.cocci scripts/coccinelle/misc/orplus.cocci scripts/coccinelle/misc/irqf_oneshot.cocci scripts/coccinelle/misc/boolconv.cocci scripts/coccinelle/misc/ifcol.cocci scripts/coccinelle/misc/semicolon.cocci scripts/coccinelle/misc/array_size.cocci scripts/coccinelle/misc/boolinit.cocci scripts/coccinelle/misc/returnvar.cocci scripts/coccinelle/misc/cstptr.cocci scripts/coccinelle/misc/badty.cocci scripts/coccinelle/misc/ifaddr.cocci scripts/coccinelle/misc/doubleinit.cocci scripts/coccinelle/misc/bugon.cocci scripts/coccinelle/locks/mini_lock.cocci scripts/coccinelle/locks/call_kern.cocci scripts/coccinelle/locks/flags.cocci scripts/coccinelle/locks/double_lock.cocci scripts/coccinelle/free/ifnullfree.cocci scripts/coccinelle/free/kfreeaddr.cocci scripts/coccinelle/free/pci_free_consistent.cocci scripts/coccinelle/free/devm_free.cocci scripts/coccinelle/free/kfree.cocci scripts/coccinelle/free/clk_put.cocci scripts/coccinelle/free/iounmap.cocci scripts/coccinelle/tests/doubletest.cocci scripts/coccinelle/tests/odd_ptr_err.cocci scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci scripts/coccinelle/tests/doublebitand.cocci scripts/coccinelle/null/deref_null.cocci scripts/coccinelle/null/badzero.cocci scripts/coccinelle/null/eno.cocci scripts/coccinelle/null/kmerr.cocci scripts/coccinelle/api/memdup.cocci scripts/coccinelle/api/alloc/pool_zalloc-simple.cocci scripts/coccinelle/api/alloc/zalloc-simple.cocci scripts/coccinelle/api/alloc/alloc_cast.cocci scripts/coccinelle/api/platform_no_drv_owner.cocci scripts/coccinelle/api/memdup_user.cocci scripts/coccinelle/api/ptr_ret.cocci scripts/coccinelle/api/drm-get-put.cocci scripts/coccinelle/api/d_find_alias.cocci scripts/coccinelle/api/pm_runtime.cocci scripts/coccinelle/api/kstrdup.cocci scripts/coccinelle/api/resource_size.cocci scripts/coccinelle/api/vma_pages.cocci scripts/coccinelle/api/check_bq27xxx_data.cocci scripts/coccinelle/api/simple_open.cocci scripts/coccinelle/api/err_cast.cocci scripts/coccinelle/api/debugfs/debugfs_simple_attr.cocci scripts/coccinelle/iterators/fen.cocci scripts/coccinelle/iterators/list_entry_update.cocci scripts/coccinelle/iterators/itnull.cocci scripts/coccinelle/iterators/use_after_iter.cocci scripts/coccinelle/iterators/device_node_continue.cocci)


cd /home/benni/xp/linux
commits=`git log --pretty=format:%h -n20`
cd /home/benni/xp/src/

echo ${#patches_list[@]} scripts founds.
echo ${#commits[@]} commits to handle.
for commit_hash in ${commits[@]} ; do
	echo $commit_hash
	if [ ! -d /home/benni/xp/src/${commit_hash} ] ; then
		mkdir /home/benni/xp/src/${commit_hash}
		cd /home/benni/xp/src/${commit_hash}
		echo "Copying linux kernel..."
		time cp -r /home/benni/xp/linux ./
		cd ./linux
		git checkout $commit_hash
		mkdir /home/benni/xp/src/${commit_hash}/outputs
		for cocci_script in ${patches_list[@]} ; do
			name=`basename ${cocci_script}`
			IFS='.' read -ra SPLIT <<< $name
			folder_name_of_script=${SPLIT[0]}
			echo "Applying coccicheck..."
			time make coccicheck J=8 COCCI=${cocci_script} MODE=patch -o /home/benni/xp/src/${commit_hash}/outputs/${folder_name_of_script}.output
		done

		for cocci_script in ${patches_list[@]} ; do
			name=`basename ${cocci_script}`
			IFS='.' read -ra SPLIT <<< $name
			folder_name_of_script=${SPLIT[0]}
			echo "Applying coccicheck..."
			time patch -p 1 -d /home/benni/xp/src/${commit_hash}/linux/ < /home/benni/xp/src/${commit_hash}/outputs/${folder_name_of_script}.output
			# time make coccicheck J=8 COCCI=${cocci_script} MODE=patch -o /home/benni/xp/src/${commit_hash}/outputs/${folder_name_of_script}.output
		done

	else
		echo "Skipping $commit_hash. Already done!"
	fi
done

# patch -p 1 -d WHERE_THE_LINUX_SRC_IS < DAT_FUCKING_COCCI_PATCH

# Detecter des interactions
# Approches combinatoires -> impossibles
# Générer tous les patchs en parallèle, les appliquer tous sur le noyau, et redemander à générer des patchs. Si la deuxième génération ne rend pas qqch de vide => erreur
# Générer tous les patchs en parallèle, appliquer le premier, générer à nouveau tous les patches, si les deux ensembles de patchs sont différents -> interaction
