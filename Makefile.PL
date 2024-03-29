use ExtUtils::MakeMaker;

use 5.010;

WriteMakefile(
	      'NAME'           => 'XML::TMX',
	      'VERSION_FROM'   => 'lib/XML/TMX.pm',
	      'AUTHOR'         => 'Projecto Natura',
	      'ABSTRACT'       => 'TMX tools',
	      'EXE_FILES'      => [
                                   qw!scripts/tmxsplit
                                      scripts/tmxuniq
                                      scripts/tmx-POStagger
                                      scripts/tmx-tokenize
                                      scripts/tmxclean
                                      scripts/tmxwc
                                      scripts/tmx2html
                                      scripts/tmxgrep
                                      scripts/tmx2tmx!],
	      'PREREQ_PM'      => {
				   'Test::Pod'           => '1.00',
				   'Test::Pod::Coverage' => '0.08',
				   'XML::DT'             => '0.57',
				   'Exporter'            => '0',
				  },
	     );
