use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'		=> 'Class::DBI::Plugin::Connection',
	'VERSION_FROM'	=> 'lib/Class/DBI/Plugin/Connection.pm',
	'PREREQ_PM'	=> {
		'Class::DBI'	=> undef,
	},
);
1;
__END__
