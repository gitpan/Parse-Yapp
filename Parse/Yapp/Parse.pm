#########################################################################
#
#      This file was generated using Parse::Yapp version 0.14.
#
#          Don't edit this file, use source file instead.
#
#               ANY CHANGE MADE HERE WILL BE LOST !
#
#########################################################################
package Parse::Yapp::Parse;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );

use Parse::Yapp::Driver;

# (c) Copyright Francois Desarmenien 1998, all rights reserved.
# (see COPYRIGHT in Parse::Yapp.pm pod section for use and distribution rights)
#
# Parse/Yapp/Parser.yp: Parse::Yapp::Parser.pm source file
#
# Use: yapp.pl -m 'Parse::Yapp::Parse' -o Parse/Yapp/Parse.pm YappParse.yp
#
# to generate the Parser module.
# 

require 5.004;

use Carp;

my($input,$lexlevel,@lineno,$nberr,$prec,$labelno);
my($syms,$head,$tail,$token,$term,$nterm,$rules,$precterm,$start,$nullable);



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '0.14',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'TOKEN' => 1,
			'TYPE' => 2,
			"%%" => -6,
			"\n" => 5,
			'UNION' => 6,
			'ASSOC' => 7,
			'error' => 8,
			'HEADCODE' => 11,
			'START' => 13
		},
		GOTOS => {
			'decl' => 4,
			'yapp' => 9,
			'head' => 3,
			'decls' => 10,
			'headsec' => 12
		}
	},
	{#State 1
		ACTIONS => {
			"<" => 14
		},
		DEFAULT => -18,
		GOTOS => {
			'typedecl' => 15
		}
	},
	{#State 2
		ACTIONS => {
			"<" => 14
		},
		DEFAULT => -18,
		GOTOS => {
			'typedecl' => 16
		}
	},
	{#State 3
		ACTIONS => {
			'error' => 19,
			'IDENT' => 18
		},
		GOTOS => {
			'rules' => 20,
			'rulesec' => 17,
			'body' => 21
		}
	},
	{#State 4
		DEFAULT => -9
	},
	{#State 5
		DEFAULT => -10
	},
	{#State 6
		ACTIONS => {
			'CODE' => 22
		}
	},
	{#State 7
		ACTIONS => {
			"<" => 14
		},
		DEFAULT => -18,
		GOTOS => {
			'typedecl' => 23
		}
	},
	{#State 8
		ACTIONS => {
			"\n" => 24
		}
	},
	{#State 9
		ACTIONS => {
			'' => 25
		}
	},
	{#State 10
		ACTIONS => {
			'TOKEN' => 1,
			'TYPE' => 2,
			"%%" => -7,
			"\n" => 5,
			'UNION' => 6,
			'ASSOC' => 7,
			'error' => 8,
			'HEADCODE' => 11,
			'START' => 13
		},
		GOTOS => {
			'decl' => 26
		}
	},
	{#State 11
		ACTIONS => {
			"\n" => 27
		}
	},
	{#State 12
		ACTIONS => {
			"%%" => 28
		}
	},
	{#State 13
		ACTIONS => {
			'IDENT' => 29
		},
		GOTOS => {
			'ident' => 30
		}
	},
	{#State 14
		ACTIONS => {
			'IDENT' => 31
		}
	},
	{#State 15
		ACTIONS => {
			'IDENT' => 29,
			'LITERAL' => 35
		},
		GOTOS => {
			'ident' => 32,
			'symlist' => 33,
			'symbol' => 34
		}
	},
	{#State 16
		ACTIONS => {
			'IDENT' => 29
		},
		GOTOS => {
			'identlist' => 36,
			'ident' => 37
		}
	},
	{#State 17
		ACTIONS => {
			"%%" => 38,
			'error' => 19,
			'IDENT' => 18
		},
		GOTOS => {
			'rules' => 39
		}
	},
	{#State 18
		ACTIONS => {
			":" => 40
		}
	},
	{#State 19
		ACTIONS => {
			";" => 41
		}
	},
	{#State 20
		DEFAULT => -26
	},
	{#State 21
		ACTIONS => {
			'TAILCODE' => 42
		},
		GOTOS => {
			'tail' => 43
		}
	},
	{#State 22
		ACTIONS => {
			"\n" => 44
		}
	},
	{#State 23
		ACTIONS => {
			'IDENT' => 29,
			'LITERAL' => 35
		},
		GOTOS => {
			'ident' => 32,
			'symlist' => 45,
			'symbol' => 34
		}
	},
	{#State 24
		DEFAULT => -17
	},
	{#State 25
		DEFAULT => 0
	},
	{#State 26
		DEFAULT => -8
	},
	{#State 27
		DEFAULT => -14
	},
	{#State 28
		DEFAULT => -5
	},
	{#State 29
		DEFAULT => -4
	},
	{#State 30
		ACTIONS => {
			"\n" => 46
		}
	},
	{#State 31
		ACTIONS => {
			">" => 47
		}
	},
	{#State 32
		DEFAULT => -3
	},
	{#State 33
		ACTIONS => {
			"\n" => 49,
			'IDENT' => 29,
			'LITERAL' => 35
		},
		GOTOS => {
			'ident' => 32,
			'symbol' => 48
		}
	},
	{#State 34
		DEFAULT => -21
	},
	{#State 35
		DEFAULT => -2
	},
	{#State 36
		ACTIONS => {
			"\n" => 51,
			'IDENT' => 29
		},
		GOTOS => {
			'ident' => 50
		}
	},
	{#State 37
		DEFAULT => -23
	},
	{#State 38
		DEFAULT => -24
	},
	{#State 39
		DEFAULT => -25
	},
	{#State 40
		ACTIONS => {
			'CODE' => 57,
			'IDENT' => 29,
			'LITERAL' => 35
		},
		DEFAULT => -33,
		GOTOS => {
			'rule' => 56,
			'rhss' => 52,
			'rhselt' => 53,
			'code' => 58,
			'ident' => 32,
			'rhs' => 59,
			'rhselts' => 54,
			'symbol' => 55
		}
	},
	{#State 41
		DEFAULT => -28
	},
	{#State 42
		DEFAULT => -43
	},
	{#State 43
		DEFAULT => -1
	},
	{#State 44
		DEFAULT => -15
	},
	{#State 45
		ACTIONS => {
			"\n" => 60,
			'IDENT' => 29,
			'LITERAL' => 35
		},
		GOTOS => {
			'ident' => 32,
			'symbol' => 48
		}
	},
	{#State 46
		DEFAULT => -13
	},
	{#State 47
		DEFAULT => -19
	},
	{#State 48
		DEFAULT => -20
	},
	{#State 49
		DEFAULT => -11
	},
	{#State 50
		DEFAULT => -22
	},
	{#State 51
		DEFAULT => -16
	},
	{#State 52
		ACTIONS => {
			";" => 61,
			"|" => 62
		}
	},
	{#State 53
		DEFAULT => -36
	},
	{#State 54
		ACTIONS => {
			'CODE' => 57,
			'IDENT' => 29,
			'LITERAL' => 35
		},
		DEFAULT => -34,
		GOTOS => {
			'rhselt' => 63,
			'code' => 58,
			'ident' => 32,
			'symbol' => 55
		}
	},
	{#State 55
		DEFAULT => -37
	},
	{#State 56
		DEFAULT => -30
	},
	{#State 57
		DEFAULT => -42
	},
	{#State 58
		DEFAULT => -38
	},
	{#State 59
		ACTIONS => {
			'PREC' => 64
		},
		DEFAULT => -32,
		GOTOS => {
			'prec' => 65
		}
	},
	{#State 60
		DEFAULT => -12
	},
	{#State 61
		DEFAULT => -27
	},
	{#State 62
		ACTIONS => {
			'CODE' => 57,
			'IDENT' => 29,
			'LITERAL' => 35
		},
		DEFAULT => -33,
		GOTOS => {
			'rule' => 66,
			'rhselt' => 53,
			'code' => 58,
			'ident' => 32,
			'rhs' => 59,
			'rhselts' => 54,
			'symbol' => 55
		}
	},
	{#State 63
		DEFAULT => -35
	},
	{#State 64
		ACTIONS => {
			'IDENT' => 29,
			'LITERAL' => 35
		},
		GOTOS => {
			'ident' => 32,
			'symbol' => 67
		}
	},
	{#State 65
		ACTIONS => {
			'CODE' => 57
		},
		DEFAULT => -40,
		GOTOS => {
			'code' => 69,
			'epscode' => 68
		}
	},
	{#State 66
		DEFAULT => -29
	},
	{#State 67
		DEFAULT => -39
	},
	{#State 68
		DEFAULT => -31
	},
	{#State 69
		DEFAULT => -41
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'yapp', 3, undef
	],
	[#Rule 2
		 'symbol', 1,
sub {

                        exists($$syms{$_[1][0]})
                    or  do {
                        $$syms{$_[1][0]} = $_[1][1];
                        $$term{$_[1][0]} = undef;
                    };
                    $_[1]
                
}
	],
	[#Rule 3
		 'symbol', 1, undef
	],
	[#Rule 4
		 'ident', 1,
sub {

                        exists($$syms{$_[1][0]})
                    or  do {
                        $$syms{$_[1][0]} = $_[1][1];
                        $$term{$_[1][0]} = undef;
                    };
                    $_[1]
                
}
	],
	[#Rule 5
		 'head', 2, undef
	],
	[#Rule 6
		 'headsec', 0, undef
	],
	[#Rule 7
		 'headsec', 1, undef
	],
	[#Rule 8
		 'decls', 2, undef
	],
	[#Rule 9
		 'decls', 1, undef
	],
	[#Rule 10
		 'decl', 1, undef
	],
	[#Rule 11
		 'decl', 4,
sub {

                for (@{$_[3]}) {
                    my($symbol,$lineno)=@$_;

                        exists($$token{$symbol})
                    and do {
                        _SyntaxError(0,
                                "Token $symbol redefined: ".
                                "Previously defined line $$syms{$symbol}",
                                $lineno);
                        next;
                    };
                    $$token{$symbol}=$lineno;
                    $$term{$symbol} = [ ];
                }
                undef
            
}
	],
	[#Rule 12
		 'decl', 4,
sub {

                for (@{$_[3]}) {
                    my($symbol,$lineno)=@$_;

                        defined($$term{$symbol}[0])
                    and do {
                        _SyntaxError(1,
                            "Precedence for symbol $symbol redefined: ".
                            "Previously defined line $$syms{$symbol}",
                            $lineno);
                        next;
                    };
                    $$term{$symbol} = [ $_[1][0], $prec ];
                }
                ++$prec;
                undef
            
}
	],
	[#Rule 13
		 'decl', 3,
sub {
 $start=$_[2][0]; undef 
}
	],
	[#Rule 14
		 'decl', 2,
sub {
 $head.=$_[1][0]; undef 
}
	],
	[#Rule 15
		 'decl', 3,
sub {
 undef 
}
	],
	[#Rule 16
		 'decl', 4,
sub {

                for ( @{$_[3]} ) {
                    my($symbol,$lineno)=@$_;

                        exists($$nterm{$symbol})
                    and do {
                        _SyntaxError(0,
                                "Non-terminal $symbol redefined: ".
                                "Previously defined line $$syms{$symbol}",
                                $lineno);
                        next;
                    };
                    delete($$term{$symbol});   #not a terminal
                    $$nterm{$symbol}=undef;    #is a non-terminal
                }
            
}
	],
	[#Rule 17
		 'decl', 2,
sub {
 $_[0]->YYErrok 
}
	],
	[#Rule 18
		 'typedecl', 0, undef
	],
	[#Rule 19
		 'typedecl', 3, undef
	],
	[#Rule 20
		 'symlist', 2,
sub {
 push(@{$_[1]},$_[2]); $_[1] 
}
	],
	[#Rule 21
		 'symlist', 1,
sub {
 [ $_[1] ] 
}
	],
	[#Rule 22
		 'identlist', 2,
sub {
 push(@{$_[1]},$_[2]); $_[1] 
}
	],
	[#Rule 23
		 'identlist', 1,
sub {
 [ $_[1] ] 
}
	],
	[#Rule 24
		 'body', 2,
sub {

                    $start
                or  $start=$$rules[1][0];

                    ref($$nterm{$start})
                or  _SyntaxError(2,"Start symbol $start not found ".
                                   "in rules section",$_[2][1]);

                $$rules[0]=[ '$start', [ $start, chr(0) ], undef, undef ];
            
}
	],
	[#Rule 25
		 'rulesec', 2, undef
	],
	[#Rule 26
		 'rulesec', 1, undef
	],
	[#Rule 27
		 'rules', 4,
sub {
 _AddRules($_[1],$_[3]); undef 
}
	],
	[#Rule 28
		 'rules', 2,
sub {
 $_[0]->YYErrok 
}
	],
	[#Rule 29
		 'rhss', 3,
sub {
 push(@{$_[1]},$_[3]); $_[1] 
}
	],
	[#Rule 30
		 'rhss', 1,
sub {
 [ $_[1] ] 
}
	],
	[#Rule 31
		 'rule', 3,
sub {
 push(@{$_[1]}, $_[2], $_[3][0]); $_[1] 
}
	],
	[#Rule 32
		 'rule', 1,
sub {

                                my($code)=undef;

                                    defined($_[1])
                                and $_[1][-1][0] eq 'CODE'
                                and $code = ${pop(@{$_[1]})}[1][0];

                                push(@{$_[1]}, undef, $code);

                                $_[1]
                            
}
	],
	[#Rule 33
		 'rhs', 0, undef
	],
	[#Rule 34
		 'rhs', 1, undef
	],
	[#Rule 35
		 'rhselts', 2,
sub {
 push(@{$_[1]},$_[2]); $_[1] 
}
	],
	[#Rule 36
		 'rhselts', 1,
sub {
 [ $_[1] ] 
}
	],
	[#Rule 37
		 'rhselt', 1,
sub {
 [ 'SYMB', $_[1] ] 
}
	],
	[#Rule 38
		 'rhselt', 1,
sub {
 [ 'CODE', $_[1] ] 
}
	],
	[#Rule 39
		 'prec', 2,
sub {

                       	defined($$term{$_[2][0]})
                    or  do {
                        _SyntaxError(1,"No precedence for symbol $_[2][0]",
                                         $_[2][1]);
                        return undef;
                    };

                    ++$$precterm{$_[2][0]};
                    $$term{$_[2][0]}[1];
				
}
	],
	[#Rule 40
		 'epscode', 0,
sub {
 undef 
}
	],
	[#Rule 41
		 'epscode', 1,
sub {
 $_[1] 
}
	],
	[#Rule 42
		 'code', 1,
sub {
 $_[1] 
}
	],
	[#Rule 43
		 'tail', 1,
sub {
 $tail=$_[1][0] 
}
	]
],
                                  @_);
    bless($self,$class);
}


		
sub _Error {
    my($value)=$_[0]->YYCurval;

    my($what)= $token ? "input: '$$value[0]'" : "end of input";

    _SyntaxError(1,"Unexpected $what",$$value[1]);
}

sub _Lexer {
 
    #At EOF
        pos($$input) >= length($$input)
    and return('',[ undef, -1 ]);

    #In TAIL section
        $lexlevel > 1
    and do {
        my($pos)=pos($$input);

        $lineno[0]=$lineno[1];
        $lineno[1]=-1;
        pos($$input)=length($$input);
        return('TAILCODE',[ substr($$input,$pos), $lineno[0] ]);
    };

    #Skip blanks
            $lexlevel == 0
        ?   $$input=~m{\G((?:
                                [\t\ ]+    # Any white space char but \n
                            |   \#[^\n]*  # Perl like comments
                            |   /\*.*?\*/ # C like comments
                            )+)}xsgc
        :   $$input=~m{\G((?:
                                \s+       # any white space char
                            |   \#[^\n]*  # Perl like comments
                            |   /\*.*?\*/ # C like comments
                            )+)}xsgc
    and do {
        my($blanks)=$1;

        #Maybe At EOF
            pos($$input) >= length($$input)
        and return('',[ undef, -1 ]);

        $lineno[1]+= $blanks=~tr/\n//;
    };

    $lineno[0]=$lineno[1];

        $$input=~/\G([A-Za-z_][A-Za-z0-9_]*)/gc
    and return('IDENT',[ $1, $lineno[0] ]);

        $$input=~/\G('(?:[^'\\]|\\'|\\)+?')/gc
    and do {
            $1 eq "'error'"
        and do {
            _SyntaxError(0,"Literal 'error' ".
                           "will be treated as error token",$lineno[0]);
            return('IDENT',[ 'error', $lineno[0] ]);
        };
        return('LITERAL',[ $1, $lineno[0] ]);
    };

        $$input=~/\G(%%)/gc
    and do {
        ++$lexlevel;
        return($1, [ $1, $lineno[0] ]);
    };

        $$input=~/\G{/gc
    and do {
        my($level,$from,$code);

        $from=pos($$input);

        $level=1;
        while($$input=~/([{}])/gc) {
                substr($$input,pos($$input)-1,1) eq '\\' #Quoted
            and next;
                $level += ($1 eq '{' ? 1 : -1)
            or last;
        }
            $level
        and  _SyntaxError(2,"Unmatched { opened line $lineno[0]",-1);
        $code = substr($$input,$from,pos($$input)-$from-1);
        $lineno[1]+= $code=~tr/\n//;
        return('CODE',[ $code, $lineno[0] ]);
    };

    if($lexlevel == 0) {# In head section
            $$input=~/\G%(left|right|nonassoc)/gc
        and return('ASSOC',[ uc($1), $lineno[0] ]);
            $$input=~/\G%(start)/gc
        and return('START',[ undef, $lineno[0] ]);
            $$input=~/\G%{/gc
        and do {
            my($code);

                $$input=~/\G(.*?)%}/sgc
            or  _SyntaxError(2,"Unmatched %{ opened line $lineno[0]",-1);

            $code=$1;
            $lineno[1]+= $code=~tr/\n//;
            return('HEADCODE',[ $code, $lineno[0] ]);
        };
            $$input=~/\G%(token)/gc
        and return('TOKEN',[ undef, $lineno[0] ]);
            $$input=~/\G%(type)/gc
        and return('TYPE',[ undef, $lineno[0] ]);
            $$input=~/\G%(union)/gc
        and return('UNION',[ undef, $lineno[0] ]);

    }
    else {# In rule section
            $$input=~/\G%(prec)/gc
        and return('PREC',[ undef, $lineno[0] ]);
    }

    #Always return something
        $$input=~/\G(.)/sg
    or  die "Parse::Yapp::Grammar::Parse: Match (.) failed: report as a BUG";

        $1 eq "\n"
    and ++$lineno[1];

    ( $1 ,[ $1, $lineno[0] ]);

}

sub _SyntaxError {
    my($level,$message,$lineno)=@_;

    $message= "*".
              [ 'Warning', 'Error', 'Fatal' ]->[$level].
              "* $message, at ".
              ($lineno < 0 ? "eof" : "line $lineno").
              ".\n";

        $level > 1
    and die $message;

    warn $message;

        $level > 0
    and ++$nberr;

        $nberr == 20 
    and die "*Fatal* Too many errors detected.\n"
}

sub _AddRules {
    my($lhs,$lineno)=@{$_[0]};
    my($rhss)=$_[1];

        ref($$nterm{$lhs})
    and do {
        _SyntaxError(1,"Non-terminal $lhs redefined: ".
                       "Previously declared line $$syms{$lhs}",$lineno);
        return;
    };

        ref($$term{$lhs})
    and do {
        my($where) = exists($$token{$lhs}) ? $$token{$lhs} : $$syms{$lhs};
        _SyntaxError(1,"Non-terminal $lhs previously ".
                       "declared as token line $where",$lineno);
        return;
    };

        ref($$nterm{$lhs})      #declared through %type
    or  do {
            $$syms{$lhs}=$lineno;   #Say it's declared here
            delete($$term{$lhs});   #No more a terminal
    };
    $$nterm{$lhs}=[];       #It's a non-terminal now

    my($epsrules)=0;        #To issue a warning if more than one epsilon rule

    for my $rhs (@$rhss) {
        my($tmprule)=[ $lhs, [ ], splice(@$rhs,-2) ]; #Init rule

            @$rhs
        or  do {
            ++$$nullable{$lhs};
            ++$epsrules;
        };

        for (0..$#$rhs) {
            my($what,$value)=@{$$rhs[$_]};

                $what eq 'CODE'
            and do {
                my($name)='@'.++$labelno."-$_";
                push(@$rules,[ $name, [], undef, $$value[0] ]);
                push(@{$$tmprule[1]},$name);
                next;
            };
            push(@{$$tmprule[1]},$$value[0]);
        }
        push(@$rules,$tmprule);
        push(@{$$nterm{$lhs}},$#$rules);
    }

        $epsrules > 1
    and _SyntaxError(0,"More than one empty rule for symbol $lhs",$lineno);
}

sub Parse {
    my($self)=shift;

        @_ > 0
    or  croak("No input grammar\n");

    my($parsed)={};

    $input=\$_[0];

    $lexlevel=0;
    @lineno=(1,1);
    $nberr=0;
    $prec=0;
    $labelno=0;

    $head="";
    $tail="";

    $syms={};
    $token={};
    $term={};
    $nterm={};
    $rules=[ undef ];   #reserve slot 0 for start rule
    $precterm={};

    $start="";
    $nullable={};

    pos($$input)=0;


    $self->YYParse(yylex => \&_Lexer, yyerror => \&_Error );

        $nberr
    and _SyntaxError(2,"Errors detected: No output",-1);

    @$parsed{ 'HEAD', 'TAIL', 'RULES', 'NTERM', 'TERM',
              'NULL', 'PREC', 'SYMS',  'START' }
    =       (  $head,  $tail,  $rules,  $nterm,  $term,
               $nullable, $precterm, $syms, $start);

    undef($input);
    undef($lexlevel);
    undef(@lineno);
    undef($nberr);
    undef($prec);
    undef($labelno);

    undef($head);
    undef($tail);

    undef($syms);
    undef($token);
    undef($term);
    undef($nterm);
    undef($rules);
    undef($precterm);

    undef($start);
    undef($nullable);

    $parsed
}


1;
