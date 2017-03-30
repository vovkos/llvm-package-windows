use strict;

my $argCount = @ARGV;
if (!$argCount)
{
	die ("Usage: patch-llvm-config.pl <LLVMConfig.cmake>");
}

my $fileName = $ARGV [0];
open (my $file, "<", $fileName) or die ("Can't open $fileName for reading: $!");

my @body = "get_filename_component (LLVM_ROOT_DIR \${CMAKE_CURRENT_LIST_DIR}/../../.. ABSOLUTE)\n\n";

while (my $s = <$file>)
{
	$s =~ s/set\s*\(LLVM_TOOLS_BINARY_DIR[^)]+\)/set(LLVM_TOOLS_BINARY_DIR \${LLVM_ROOT_DIR}\/bin)/;
	$s =~ s/set\s*\(LLVM_INSTALL_PREFIX[^)]+\)/set(LLVM_INSTALL_PREFIX \${LLVM_ROOT_DIR})/;
	$s =~ s/LLVM-Config\s/\${CMAKE_CURRENT_LIST_DIR}\/LLVM-Config.cmake /;

	push (@body, $s)
}

open (my $file, ">", $fileName) or die ("Can't open $fileName for writing: $!");
print $file (@body);
