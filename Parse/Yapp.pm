#
# Module Parse::Yapp.pm.
#
# Copyright (c) 1998, Francois Desarmenien, all right reserved.
#
# See the Copyright section at the end of the Parse/Yapp.pm pod section
# for usage and distribution rights.
#
#
package Parse::Yapp;

use strict;
use vars qw($VERSION @ISA);
@ISA = qw(Parse::Yapp::Output);

use Parse::Yapp::Output;

# $VERSION is in Parse/Yapp/Driver.pm


1;

__END__

=head1 NAME

Parse::Yapp - Perl extension for generating and using LALR parsers. 

=head1 SYNOPSIS

  yapp.pl -m MyParser grammar_file.yp

  ...

  use MyParser;

  $parser=new MyParser();
  $value=$parser->YYParse(yylex => \&lexer_sub, yyerror => \&error_sub);

  $nberr=$parser->YYNberr();

  $parser->YYData->{DATA}= [ 'Anything', 'You Want' ];

  $data=$parser->YYData->{DATA}[0];

=head1 DESCRIPTION

Parse::Yapp (Yet Another Perl Parser compiler) is a collection of modules
that let you generate and use yacc like parsers with perl object oriented
interface.

The script yapp.pl is a front-end to the Parse::Yapp module and let you
easily create a Perl OO parser from an input grammar file.

=head2 The Grammar file

=over 4

=item C<Comments>

Through all your files, comments are either Perl style, introduced by I<#>
up to the end of line, or C style, enclosed between  I</*> and I<*/>.


=item C<Tokens and string literals>


Through all the grammar files, two kind of symbols may appear:
I<Non-terminals> symbols, also called I<left-hand-side> symbols,
which are the names of your rules, and I<Terminal> symbols, also
called I<Tokens>.

Tokens are the symbols your lexer function will pass to your parser
(see below). They come in two flavours: symbolic tokens and string
literals.

Non-terminals and symbolic tokens share the same identifier syntax:

		[A-Za-z][A-Za-z0-9_]*

String literals are enclosed in single quotes and can contain almost
anything. They will be output to your parser file double-quoted, making
any special character be as is. '"', '$' and '@' will be automatically
quoted with '\', making their writing more natural. On the other hand,
if you need a single quote inside your literal, just quote it with '\'.

You cannot have a literal I<'error'> in your grammar as it would
confuse the driver with the I<error> token. Use a symbolic token instead.
Using it anyway will produce a warning telling you you should have wrote
it I<error> and will treat it as if it were the I<error> token.


=item C<Grammar file syntax>

It is very close to yacc's one (in fact, I<Parse::Yapp> should compile
a I<yacc> grammar without any modification, whereas the opposit
is no true).

It is divided in three sections separated by C<%%>:

	header section
	%%
	rules section
	%%
	footer section

=over 4

=item B<The Header Section> section may contain:

=item *

One ore more code blocks enclosed inside C<%{> and C<%}> just like in
yacc. They may contain any valid Perl code and will be copied verbatim
at the very beginning of the parser module. They are not as useful as
they are in yacc, but you may use them, for example, for global variables
declaration, though you will see later that such global variables can
avoided to make reentrant parser modules.

=item *

Precedence declarations, introduced by C<%left>, C<%right> and C<%nonassoc>
specifying associativity, followed by the list of tokens or litterals
having the same precedence and associativity.
The precedence beeing the later declared have the highest level.
(see the yacc or bison manuals for a full explanation of how they work,
as they are implemented exactly the same way in Parse::Yapp)

=item *

C<%start> followed by a rule's left hand side, declaring this rule to
be the starting rule of your grammar. The default if C<%start> is not
declared is the first rule in your grammar section.

=item *

C<%token> followed by a list of symbols, forcing them to be recognized
as tokens, generating a syntax error if used in the left hand side of
a rule declaration.
Note that in Parse::Yapp, you I<don't> need to declare tokens as in yacc: any
symbol not appearing as a left hand side of a rule is considered to be
a token.
Other yacc declarations or constructs such as C<%type> and C<%union> are
parsed but (almost) ignored.

=item B<The Rule Section> contains your grammar rules:

A rule is made of a left-hand-side symbol, followed by a C<':'> and one
or more right hand sides separated by C<'|'> and terminated by a C<';'>:

    exp:    exp '+' exp
        |   exp '-' exp
        ;

A right hand side may be empty:

    input:  #empty
        |   input line
        ;

(if you have more than one empty rhs, Parse::Yapp will issue a warning,
as this is usually a mistake, and you sure will have a reduce/reduce
conflict)


A rhs may be followed by an optionnal C<%prec> directive, followed
by a token, giving the rule and explicit precedence (see yacc manuals
for its precise meaning) and optionnal semantic action code block (see
below).

    exp:   '-' exp %prec NEG { -$_[1] }
        |  exp '+' exp       { $_[1] + $_[3] }
        |  NUM
        ;

Note that in Parse::Yapp, a lhs I<cannot> appear more than once as
a rule name (This differs from yacc).


=item C<The footer section>

may contain any valid Perl code and will be appended at the very end
of your parser module. Here you can write your lexer, error report
subs and anything relevant to you parser.

=item C<Semantic actions>

Semantic actions are run every time a I<reduction> occurs in the
parsing flow and they must return a semantic value.

They are (usually, but see below C<In rule actions>) written at
the very end of the rhs, enclosed with C<{ }>, and are copied verbatim
to your parser file, inside of the rules table.

Be aware that matching braces in Perl is much more difficult than
in C: inside strings they don't need to match. While in C it is
very easy to detect the beginning of a string construct, or a
single character, it is much more difficult in Perl, as there
are so many ways of writing such literals. So there is no check
for that today. If you need a brace in a string, quote it (C<\{> or
C<\}>) that should work. Or (weird) make a comment matching it. Sorry.

    {
        "{ My string block }".
        "\{ My other string block \}".
        qq/ My unmatched brace \} /.
        #Force the match: {
        q/  My last brace } /
    }

All of these constructs should work.


In Parse::Yapp, semantic actions are called like normal Perl sub calls,
with their arguments passed in C<@_>, and their semantic value are
their return values.

$_[1] to $_[n] are the parameters just as $1 to $n in yacc, while
$_[0] is the parser object itself.

Having $_[0] beeing the parser object itself allows you to call
parser methods. Thats how the yacc macros are implemented:

	yyerrok is done by calling $_[0]->YYErrok
	YYERROR is done by calling $_[0]->YYError
	YYACCEPT is done by calling $_[0]->YYAccept
	YYABORT is done by calling $_[0]->YYAbort

All those methods explicitly return I<undef>, for convenience.

    YYRECOVERING is done by calling $_[0]->YYRecovering

Two useful methods in error recovery sub

    $_[0]->YYCurtok
    $_[0]->YYCurval

returns respectivly the current token and its semantic value that made
the parse fail (they can be used to modify their values, too, but
know what you do !).

Accessing semantics values on the left of your reducing rule is done
through the method

    $_[0]->YYSemval( index )

where index is an integer. Its value beeing I<1 .. n> returns the same values
than I<$_[1] .. $_[n]>, but I<-n .. 0> returns values on the left of the rule
beeing reduced (It is related to I<$-n .. $0 .. $n> in yacc, but you
cannot use I<$_[0]> or I<$_[-n]> constructs in Parse::Yapp for obvious reasons)


There is also a provision for user data area in the parser object,
accessed by the method:

    $_[0]->YYData

which returns a reference to an anonymous hash, letting you have
all of your parsing data held inside the object (see the Calc.yp
or the test.pl file in the distribution for some examples).
That's how you can make you parser module reentrant: all of your
module states and variables are held inside the parser object.

If no action is specified for a rule, a default action is run, which
returns the first parameter:

   { $_[1] }

=item C<In rule actions>

It is also possible to embbed semantic actions inside of a rule:

    typedef:    TYPE { $type = $_[1] } identlist { ... } ;

When the Parse::Yapp's parser encounter such an embeded action, it modifies
the grammar as if you wrote (although @x-1 is not a legal lhs value):

    @x-1:   /* empty */ { $type = $_[1] };
    typedef:    TYPE @x-1 identlist { ... } ;

where I<x> is a sequential number incremented for each "in rule" action,
and I<-1> represents the "dot position" in the rule where the action arises.

In such actions, you can use I<$_[1]..$_[n]> variables, which are the
semantic values on the left of your action.

=item C<Generating the Parser Module>

Now that you grammar file is written, you can use yapp.pl on it
to generate your parser module:

    yapp.pl -v Calc.yp

will create two files F<Calc.pm>, your parser module, and F<Calc.output>
a verbose output of your parser rules, conflicts, warnings, states
and summary.

What your are missing now is a lexer routine.

=item C<The Lexer sub>

is called each time the parser need to read the next token.

It is called with only one argument that is the parser object itself,
so you can access its methods, specially the

    $_[0]->YYData

data area.

It is its duty to return the next token and value to the parser.
They C<must> be returned as a list of two variables, the first one
beeing the token known by the parser (symbolic or literal), and the
second one beeing anything you want (usualy the text of the next
token, or the literal value) from a simple scalar value to any
complex reference, as the parsing driver never use it but to call
semantic actions:

    ( NUMBER, $num )
or
    ( '>=', '>=' )
or
    ( 'ARRAY', [ @values ] )

When the lexer reach the end of input, it must return the C<''>
empty token with an undef value:

     ( '', undef )

Note that your lexer should I<never> return C<'error'> as token
value: for the driver, this is the error token used for error
recovery and would lead to odd reactions.

You now have your lexer written, maybe you will need to output
meaningful error messages, instead of the default which is to
print 'Parse error.' on STDERR.

So you will need an Error reporting sub.

item C<Error reporting routine>

If you want one, write it knowing that it is passed as parameter
the parser object. So you can share information whith the lexer
routine quite easily.

=item C<Parsing>

Now you've got everything to do the parsing.

First, use the parser module:

    use Calc;

Then create the parser object:

    $parser=new Calc;

Now, call the YYParse method, telling it where to find the lexer
and error report subs:

    $result=$parser->YYParse(yylex => \&Lexer,
                           yyerror => \&ErrorReport);

(assuming Lexer and ErrorReport subs have been written in your current
package)

The order in which parameters appear is unimportant.

Et voila.

The YYParse method will do the parse, then return the last semantic
value returned, or undef if error recovery cannot recover.

If you need to be sure the parse has been successful (in case your
last returned semantic value I<is> undef) make a call to:

    $parser->YYNberr()

which returns the total number of time the error reporting sub has been called.

=item C<Error Recovery>

in Parse::Yapp is implemented the same way it is in yacc.

=item C<Debugging Parser>

To debug your parser, you can call the YYParse method with a debug parameter:

    $parser->YYParse( ... , yydebug => value, ... )

where value is a bitfield, each bit representing a specific debug output:

    Bit Value    Outputs
    0x01         Token reading (useful for Lexer debugging)
    0x02         States information
    0x04         Driver actions (shifts, reduces, accept...)
    0x08         Parse Stack dump
    0x10         Error Recovery tracing

To have a full debugging ouput, use

    debug => 0x1F

Debugging output is sent to STDERR, and be aware that it can produce
C<huge> outputs.

=back

=head1 AUTHOR

Francois Desarmenien  desar@club-internet.fr

=head1 SEE ALSO

perl(1) yacc(1) bison(1).

=head1 COPYRIGHT

The Parse::Yapp module and its related modules and shell scripts are copyright
(c) 1998 Francois Desarmenien, France. All rights reserved.

You may use and distribute them under the terms of either
the GNU General Public License or the Artistic License,
as specified in the Perl README file.

=cut
