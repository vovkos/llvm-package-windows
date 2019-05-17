use strict;

my $fileName = $ARGV [0] || die ("Usage: pdb-patch.pl <AddLLVM.cmake>\n");
open (my $file, "<", $fileName) || die ("Can't open $fileName for reading: $!\n");

my $patch = '
  # <<< BEGIN PDB PATCH

  set_target_properties(${name} PROPERTIES COMPILE_PDB_NAME ${name})
  get_target_property(type ${name} TYPE)
  if(${type} STREQUAL "STATIC_LIBRARY")
    get_target_property(dir ${name} ARCHIVE_OUTPUT_DIRECTORY_DEBUG)
  else()
    get_target_property(dir ${name} LIBRARY_OUTPUT_DIRECTORY_DEBUG)
  endif()
  if(dir)
    install(FILES ${dir}/${name}.pdb CONFIGURATIONS Debug DESTINATION lib${LLVM_LIBDIR_SUFFIX})
  endif(dir)

  # >>> END PDB PATCH
';

my @body;

while (my $s = <$file>)
{
	if ($s =~ m/endmacro\s*\(add_llvm_library/)
	{
		push (@body, $patch);
	}

	push (@body, $s)
}

open (my $file, ">", $fileName) || die ("Can't open $fileName for writing: $!\n");
print $file (@body);
