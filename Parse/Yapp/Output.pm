#
# Module Parse::Yapp::Output
#
# (c) Copyright 1998 Francois Desarmenien, all rights reserved.
# (see the pod text in Parse::Yapp module for use and distribution rights)
#
package Parse::Yapp::Output;
@ISA=qw ( Parse::Yapp::Lalr );

require 5.004;

use Parse::Yapp::Lalr;
use Parse::Yapp::Driver;

use strict;

use Carp;

sub _CopyDriver {
	my($text)='#Included Parse/Yapp/Driver.pm file'.('-' x 40)."\n";
		open(DRV,$Parse::Yapp::Driver::FILENAME)
	or	die "BUG: could not open $Parse::Yapp::Driver::FILENAME";
	$text.="{\n".join('',<DRV>)."}\n";
	close(DRV);
	$text.='#End of include'.('-' x 50)."\n";
}

sub Output {
    my($self)=shift;
    my($package,$standalone)=@_;
    my($head,$states,$rules,$tail,$driver);
    my($text);
    my($version)=$Parse::Yapp::Driver::VERSION;
    my($datapos);

	$driver='use Parse::Yapp::Driver;';

        defined($package)
    or $package='Parse::Yapp::Default';

	$head= $self->Head();
	$rules=$self->RulesTable();
	$states=$self->DfaTable();
	$tail= $self->Tail();

		$standalone
	and	$driver=_CopyDriver();

    $datapos=tell(DATA);
	while(defined($_=<DATA>)) {

			/<<\$.+>>/
		and	s/<<(\$.+)>>/$1/ee;

		$text.=$_;
	}
    seek(DATA,$datapos,0);

	$text;
}

1;
 __DATA__
#########################################################################
#
#      This file was generated using Parse::Yapp version <<$version>>.
#
#          Don't edit this file, use source file instead.
#
#               ANY CHANGE MADE HERE WILL BE LOST !
#
#########################################################################
package <<$package>>;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
<<$driver>>

<<$head>>

sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '<<$version>>',
                                  yystates =>
<<$states>>,
                                  yyrules  =>
<<$rules>>,
                                  @_);
    bless($self,$class);
}

<<$tail>>
1;
