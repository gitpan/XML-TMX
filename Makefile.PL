use ExtUtils::MakeMaker;

WriteMakefile(
	      'NAME'           => 'XML::TMX',
	      'VERSION_FROM'   => 'lib/XML/TMX.pm',
	      'AUTHOR'         => 'Projecto Natura',
	      'ABSTRACT'       => 'TMX tools',
	      'EXE_FILES'      => [qw!scripts/po2tmx
				      scripts/tmxsplit
				      scripts/tmx2html
				      scripts/tmx2tmx!],
	      'PREREQ_PM'      => {
				   'Test::Pod'   => 1.00,
				   'Test::Pod::Coverage' => 0.08,
				   'XML::DT'     => 0.27,
				   'Exporter'    => 0,
				  },
	     );
