#!/usr/bin/perl
use warnings;
use strict;

use Cwd;
use Test::Simple tests => 84;

$ENV{PERL5LIB}="./build/lib/";

my $CWD = getcwd();
my $TMPDIR = "$CWD/tmp/";
my $HYBRID_COPY_SRC = "$CWD/build/tests/copy_area";

main();
exit 0;

sub main {
	system("rm", '-rf', $TMPDIR);
	mkdir $TMPDIR or die "Failed to create dir '$TMPDIR': $!\n";

	end_result_tests();
}

sub end_result_tests {
	my $test_category = "end_result";
	my $test_tmp = "$TMPDIR/$test_category";
	my $bin = "$CWD/build/bin/hybridize";
	my $test_name;
	my $ret;

	print "\n\nStarting tests module: $test_category\n";

	
	system("rm", '-rf', $test_tmp);
	mkdir $test_tmp or die "failed to create dir '$test_tmp': $!\n";
	$test_name = "full_link";
	$ret = system($bin,
		'--whitelist', "$CWD/build/tests/areas/$test_name/whitelist",
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	ok($ret == 0, "$test_category - $test_name: exits with 0") or exit 1;
	ok(-l "$test_tmp/file_link", "$test_category - $test_name: file link") or exit 1;
	ok(-l "$test_tmp/dir_link", "$test_category - $test_name: dir link") or exit 1;
	ok(-l "$test_tmp/empty_dir_link", "$test_category - $test_name: empty dir link") or exit 1;
	ok(-l "$test_tmp/dir", "$test_category - $test_name: dir") or exit 1;
	ok(-f "$test_tmp/dir/file", "$test_category - $test_name: dir/file") or exit 1;
	ok(-f "$test_tmp/dir/empty_file", "$test_category - $test_name: dir/empty_file") or exit 1;
	ok(-l "$test_tmp/empty_dir", "$test_category - $test_name: empty_dir") or exit 1;
	ok(-l "$test_tmp/empty_file", "$test_category - $test_name: empty_file") or exit 1;
	ok(-l "$test_tmp/file", "$test_category - $test_name: file") or exit 1;

	$test_name = "full_copy";
	system("rm", '-rf', $test_tmp);
	mkdir $test_tmp or die "failed to create dir '$test_tmp': $!\n";
	$ret = system($bin,
		'--whitelist', "$CWD/build/tests/areas/$test_name/whitelist",
		$HYBRID_COPY_SRC,
		$test_tmp,
	);
	ok($ret == 0, "$test_category - $test_name: exits with 0") or exit 1;
	ok(-l "$test_tmp/file_link", "$test_category - $test_name: file link") or exit 1;
	ok(-l "$test_tmp/dir_link", "$test_category - $test_name: dir link") or exit 1;
	ok(-l "$test_tmp/empty_dir_link", "$test_category - $test_name: empty dir link") or exit 1;
	ok(-d "$test_tmp/dir", "$test_category - $test_name: dir") or exit 1;
	ok(-f "$test_tmp/dir/file", "$test_category - $test_name: dir/file") or exit 1;
	ok(-f "$test_tmp/dir/empty_file", "$test_category - $test_name: dir/empty_file") or exit 1;
	ok(-d "$test_tmp/empty_dir", "$test_category - $test_name: empty_dir") or exit 1;
	ok(-f "$test_tmp/empty_file", "$test_category - $test_name: empty_file") or exit 1;
	ok(-f "$test_tmp/file", "$test_category - $test_name: file") or exit 1;


	$test_name = "mixed_copy";
	system("rm", '-rf', $test_tmp);
	mkdir $test_tmp or die "failed to create dir '$test_tmp': $!\n";
	$ret = system($bin,
		'--whitelist', "$CWD/build/tests/areas/$test_name/whitelist",
		$HYBRID_COPY_SRC,
		$test_tmp,
	);
	ok($ret == 0, "$test_category - $test_name: exits with 0") or exit 1;
	ok(-l "$test_tmp/file_link", "$test_category - $test_name: file link") or exit 1;
	ok(-l "$test_tmp/dir_link", "$test_category - $test_name: dir link") or exit 1;
	ok(-l "$test_tmp/empty_dir_link", "$test_category - $test_name: empty dir link") or exit 1;
	ok(-d "$test_tmp/dir", "$test_category - $test_name: dir") or exit 1;
	ok(-f "$test_tmp/dir/file", "$test_category - $test_name: dir/file") or exit 1;
	ok(-l "$test_tmp/dir/empty_file", "$test_category - $test_name: dir/empty_file") or exit 1;
	ok(-d "$test_tmp/empty_dir", "$test_category - $test_name: empty_dir") or exit 1;
	ok(-l "$test_tmp/empty_file", "$test_category - $test_name: empty_file") or exit 1;
	ok(-f "$test_tmp/file", "$test_category - $test_name: file") or exit 1;

	$test_name = "link_to_full_copy";
	system("rm", '-rf', $test_tmp);
	mkdir $test_tmp or die "failed to create dir '$test_tmp': $!\n";
	system($bin, 
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	system($bin, 
		'--whitelist', "$CWD/build/tests/areas/full_copy/whitelist", 
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	ok(-l "$test_tmp/file_link", "$test_category - $test_name: file link") or exit 1;
	ok(-l "$test_tmp/dir_link", "$test_category - $test_name: dir link") or exit 1;
	ok(-l "$test_tmp/empty_dir_link", "$test_category - $test_name: empty dir link") or exit 1;
	ok(-d "$test_tmp/dir", "$test_category - $test_name: dir") or exit 1;
	ok(-f "$test_tmp/dir/file", "$test_category - $test_name: dir/file") or exit 1;
	ok(-f "$test_tmp/dir/empty_file", "$test_category - $test_name: dir/empty_file") or exit 1;
	ok(-d "$test_tmp/empty_dir", "$test_category - $test_name: empty_dir") or exit 1;
	ok(-f "$test_tmp/empty_file", "$test_category - $test_name: empty_file") or exit 1;
	ok(-f "$test_tmp/file", "$test_category - $test_name: file") or exit 1;

	$test_name = "full_to_link_copy";
	system("rm", '-rf', $test_tmp);
	mkdir $test_tmp or die "failed to create dir '$test_tmp': $!\n";
	system($bin, 
		'--whitelist', "$CWD/build/tests/areas/full_copy/whitelist",
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	system($bin, 
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	ok(-l "$test_tmp/file_link", "$test_category - $test_name: file link") or exit 1;
	ok(-l "$test_tmp/dir_link", "$test_category - $test_name: dir link") or exit 1;
	ok(-l "$test_tmp/empty_dir_link", "$test_category - $test_name: empty dir link") or exit 1;
	ok(-l "$test_tmp/dir", "$test_category - $test_name: dir") or exit 1;
	ok(-f "$test_tmp/dir/file", "$test_category - $test_name: dir/file") or exit 1;
	ok(-f "$test_tmp/dir/empty_file", "$test_category - $test_name: dir/empty_file") or exit 1;
	ok(-l "$test_tmp/empty_dir", "$test_category - $test_name: empty_dir") or exit 1;
	ok(-l "$test_tmp/empty_file", "$test_category - $test_name: empty_file") or exit 1;
	ok(-l "$test_tmp/file", "$test_category - $test_name: file") or exit 1;

	$test_name = "full_to_mixed_copy";
	system("rm", '-rf', $test_tmp);
	mkdir $test_tmp or die "failed to create dir '$test_tmp': $!\n";
	system($bin, 
		'--whitelist', "$CWD/build/tests/areas/full_copy/whitelist",
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	system($bin, 
		'--whitelist', "$CWD/build/tests/areas/mixed_copy/whitelist",
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	ok(-l "$test_tmp/file_link", "$test_category - $test_name: file link") or exit 1;
	ok(-l "$test_tmp/dir_link", "$test_category - $test_name: dir link") or exit 1;
	ok(-l "$test_tmp/empty_dir_link", "$test_category - $test_name: empty dir link") or exit 1;
	ok(-d "$test_tmp/dir", "$test_category - $test_name: dir") or exit 1;
	ok(-f "$test_tmp/dir/file", "$test_category - $test_name: dir/file") or exit 1;
	ok(-l "$test_tmp/dir/empty_file", "$test_category - $test_name: dir/empty_file") or exit 1;
	ok(-d "$test_tmp/empty_dir", "$test_category - $test_name: empty_dir") or exit 1;
	ok(-l "$test_tmp/empty_file", "$test_category - $test_name: empty_file") or exit 1;
	ok(-f "$test_tmp/file", "$test_category - $test_name: file") or exit 1;

	$test_name = "mixed_to_full_copy";
	system("rm", '-rf', $test_tmp);
	mkdir $test_tmp or die "failed to create dir '$test_tmp': $!\n";
	system($bin, 
		'--whitelist', "$CWD/build/tests/areas/mixed_copy/whitelist",
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	system($bin, 
		'--whitelist', "$CWD/build/tests/areas/full_copy/whitelist",
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	ok(-l "$test_tmp/file_link", "$test_category - $test_name: file link") or exit 1;
	ok(-l "$test_tmp/dir_link", "$test_category - $test_name: dir link") or exit 1;
	ok(-l "$test_tmp/empty_dir_link", "$test_category - $test_name: empty dir link") or exit 1;
	ok(-d "$test_tmp/dir", "$test_category - $test_name: dir") or exit 1;
	ok(-f "$test_tmp/dir/file", "$test_category - $test_name: dir/file") or exit 1;
	ok(-f "$test_tmp/dir/empty_file", "$test_category - $test_name: dir/empty_file") or exit 1;
	ok(-d "$test_tmp/empty_dir", "$test_category - $test_name: empty_dir") or exit 1;
	ok(-f "$test_tmp/empty_file", "$test_category - $test_name: empty_file") or exit 1;
	ok(-f "$test_tmp/file", "$test_category - $test_name: file") or exit 1;

	$test_name = "mixed_to_full_link";
	system("rm", '-rf', $test_tmp);
	mkdir $test_tmp or die "failed to create dir '$test_tmp': $!\n";
	system($bin, 
		'--whitelist', "$CWD/build/tests/areas/mixed_copy/whitelist",
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	system($bin, 
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	ok(-l "$test_tmp/file_link", "$test_category - $test_name: file link") or exit 1;
	ok(-l "$test_tmp/dir_link", "$test_category - $test_name: dir link") or exit 1;
	ok(-l "$test_tmp/empty_dir_link", "$test_category - $test_name: empty dir link") or exit 1;
	ok(-l "$test_tmp/dir", "$test_category - $test_name: dir") or exit 1;
	ok(-f "$test_tmp/dir/file", "$test_category - $test_name: dir/file") or exit 1;
	ok(-f "$test_tmp/dir/empty_file", "$test_category - $test_name: dir/empty_file") or exit 1;
	ok(-l "$test_tmp/empty_dir", "$test_category - $test_name: empty_dir") or exit 1;
	ok(-l "$test_tmp/empty_file", "$test_category - $test_name: empty_file") or exit 1;
	ok(-l "$test_tmp/file", "$test_category - $test_name: file") or exit 1;

	$test_name = "link_to_mixed_copy";
	system("rm", '-rf', $test_tmp);
	mkdir $test_tmp or die "failed to create dir '$test_tmp': $!\n";
	system($bin, 
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	system($bin, 
		'--whitelist', "$CWD/build/tests/areas/mixed_copy/whitelist",
		$HYBRID_COPY_SRC, 
		$test_tmp, 
	);
	ok(-l "$test_tmp/file_link", "$test_category - $test_name: file link") or exit 1;
	ok(-l "$test_tmp/dir_link", "$test_category - $test_name: dir link") or exit 1;
	ok(-l "$test_tmp/empty_dir_link", "$test_category - $test_name: empty dir link") or exit 1;
	ok(-d "$test_tmp/dir", "$test_category - $test_name: dir") or exit 1;
	ok(-f "$test_tmp/dir/file", "$test_category - $test_name: dir/file") or exit 1;
	ok(-l "$test_tmp/dir/empty_file", "$test_category - $test_name: dir/empty_file") or exit 1;
	ok(-d "$test_tmp/empty_dir", "$test_category - $test_name: empty_dir") or exit 1;
	ok(-l "$test_tmp/empty_file", "$test_category - $test_name: empty_file") or exit 1;
	ok(-f "$test_tmp/file", "$test_category - $test_name: file") or exit 1;

}
