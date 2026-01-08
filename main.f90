program main
   use mpas_derived_types
   use mpas_subdriver
   implicit none

   type(domain_type), pointer :: domain
   type(core_type), pointer :: corelist

   call mpas_init(corelist, domain)
end program main