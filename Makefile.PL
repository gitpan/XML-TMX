use ExtUtils::MakeMaker;

WriteMakefile(
	      'NAME'           => 'XML::TMX',
	      'VERSION_FROM'   => 'TMX.pm',
	      'AUTHOR'         => 'Projecto Natura',
	      'ABSTRACT'       => 'TMX tools',
	      'PREREQ_PM'	   => {
				       'XML::DT'     => 0.24,
				       'Exporter'    => 0,
				      },
	     );
