use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Parse::Yapp',
    'VERSION_FROM' => 'Parse/Yapp/Driver.pm', # finds $VERSION
    'MAN3PODS' => { 'Parse/Yapp.pm' => '$(INST_MAN3DIR)/Parse::Yapp.3' },
    'PM' => {
              'Parse/Yapp.pm' => '$(INST_LIBDIR)/Yapp.pm',
              'Parse/Yapp/Driver.pm' => '$(INST_LIBDIR)/Yapp/Driver.pm',
              'Parse/Yapp/Grammar.pm' => '$(INST_LIBDIR)/Yapp/Grammar.pm',
              'Parse/Yapp/Lalr.pm' => '$(INST_LIBDIR)/Yapp/Lalr.pm',
              'Parse/Yapp/Output.pm' => '$(INST_LIBDIR)/Yapp/Output.pm',
              'Parse/Yapp/Parse.pm' => '$(INST_LIBDIR)/Yapp/Parse.pm'
            },
	'EXE_FILES' => [ 'yapp.pl' ],
);

sub MY::postamble {
<<'EOT';
YAPPPARSE = Parse/Yapp/Parse.pm

$(YAPPPARSE) :: YappParse.yp
	$(PERL) yapp.pl -m 'Parse::Yapp::Parse' -o 'Parse/Yapp/Parse.pm' YappParse.yp
EOT
}
