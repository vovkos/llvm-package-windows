use strict;

my $fileName = $ARGV [0] || die ("Usage: pdb-patch.pl <AddLLVM.cmake>\n");
open (my $file, "<", $fileName) || die ("Can't open $fileName for reading: $!\n");

my $patch = '
  # <<< BEGIN PDB PATCH

  get_target_property(type ${name} TYPE)
  if(${type} STREQUAL "STATIC_LIBRARY")
    set(pdb_dir ${CMAKE_CURRENT_BINARY_DIR}/pdb)
    set_target_properties(
      ${name}
      PROPERTIES
        COMPILE_PDB_NAME_DEBUG ${name}
        COMPILE_PDB_OUTPUT_DIRECTORY_DEBUG ${pdb_dir}
      )
    install(
      FILES ${pdb_dir}/${name}.pdb
      CONFIGURATIONS Debug
      DESTINATION lib${LLVM_LIBDIR_SUFFIX}
      )
  endif()

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
