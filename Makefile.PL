use ExtUtils::MakeMaker;

WriteMakefile(
	      'NAME'           => 'XML::TMX',
	      'VERSION_FROM'   => 'TMX.pm',
	      'AUTHOR'         => 'Projecto Natura',
	      'ABSTRACT'       => 'TMX tools',
	      'EXE_FILES'      => [qw!scripts/po2tmx
				      scripts/tmxsplit
				      scripts/tmx2html
				      scripts/tmx2tmx!],
	      'PREREQ_PM'      => {
				   'XML::DT'     => 0.27,
				   'Exporter'    => 0,
				  },
	     );
