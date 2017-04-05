use strict;

my $fileName = $ARGV [0] || die ("Usage: patch-add-llvm.pl <AddLLVM.cmake>\n");
open (my $file, "<", $fileName) || die ("Can't open $fileName for reading: $!\n");

my @body;

while (my $s = <$file>)
{
	if ($s =~ m/endmacro\s*\(add_llvm_library/)
	{				
		push (@body, "\n");
		push (@body, "  set_target_properties(\${name} PROPERTIES COMPILE_PDB_NAME \${name})\n");
		push (@body, "  get_target_property(dir \${name} ARCHIVE_OUTPUT_DIRECTORY_DEBUG)\n");
		push (@body, "  install(FILES \${dir}/\${name}.pdb CONFIGURATIONS Debug DESTINATION lib\${LLVM_LIBDIR_SUFFIX})\n");
	}

	push (@body, $s)
}

open (my $file, ">", $fileName) || die ("Can't open $fileName for writing: $!\n");
print $file (@body);
