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

sub Output {
    my($self)=shift;
    my($package)=@_;
	my($head,$states,$rules,$tail);
    my($text);
	my($version)=$Parse::Yapp::Driver::VERSION;
    my($datapos);

        defined($package)
    or $package='Parse::Yapp::Default';

	$head= $self->Head();
	$rules=$self->RulesTable();
	$states=$self->DfaTable();
	$tail= $self->Tail();

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

use Parse::Yapp::Driver;

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
