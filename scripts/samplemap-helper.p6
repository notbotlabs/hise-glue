#!/usr/bin/env perl6

use v6.d;

constant DEBUG = 1;

multi sub MAIN(:$old = 60, :$new = 36, :$range = 0) {
	my @files = dir test => /'xml'/;
	for @files -> $f {
		say "Now processing $f";
		my $contents = $f.slurp;
		say $contents;
		for ^$range -> $idx {
			my $older = "\"{60 + $idx}\"";
			my $newer = "\"{36 + $idx}\"";
		 	say "Replacing $older with $newer";
			$contents ~~ s:g/$older/$newer/;
		}
		say $contents
            if DEBUG;
		say "Writing to $f";
		$f.spurt($contents);
		say $f.slurp;
	}
}

multi sub MAIN(:$clean-monolith!, :@files, :$old-dir='', :$new-dir='', :$write) {
	say "Cleaning monolith settings";
	@files ||= dir.grep(*.extension eq 'xml');
    dd @files;
	for @files -> $f is rw {

        if $f ~~ Str {
            $f .= IO;
        }

		say "Now cleaning $f";
		my $contents = $f.slurp;
		$contents ~~ s:g/'MonolithOffset="' \d* '"'//;
		$contents ~~ s:g/'MonolithLength="' \d* '"'//;
		$contents ~~ s:g/'SaveMode="' \d* '"'//;
		$contents ~~ s:g/'SampleRate="' \d* '"'//;
		$contents ~~ s:g/'Duplicate="1"'/Duplicate="0"/;
        if $old-dir && $new-dir {
            $contents ~~ s:g/$old-dir/$new-dir/;
        }
        if $write {
    		$f.spurt($contents);
    		say $f.slurp;
        } else {
            say $contents;
	    }
    }
}

multi sub MAIN(:$detect-off-root!, :@files) {
	say "Checking for notes where root doesn't match lo-key";
	@files ||= dir test => /'xml'/;
	for @files -> $f is rw {
        if $f ~~ Str {
            $f .= IO;
        }
        say "Processing $f";
		for $f.lines -> $l {
			$l ~~ /'Root="' $<root>=\d* '" LoKey="' $<low>=\d* '" HiKey="' $<high>=\d* '"'/;
			if ($<root> && $<low> && $<high>) {
				say $l unless $<root> == $<low> & $<high>;
				#say $l;
			}
			#say $l;
		}
	}
}

multi sub MAIN(:$show-note-to-sample-map!, :@files, :$dir='') {
    say "Getting a list of all notes to samples";
    @files ||= dir text => /'xml'/;
    dd @files;
    my %note-map;
    for @files -> $f is rw {
        say "Processing $f";

        if $f ~~ Str {
            $f .= IO;
        }
        
        my ($note, $sample);
        for $f.lines -> $l {
            $l ~~ /'Root="' $<note>=\d* '"'/;
            if $<note> {
                $note = $<note>.Str;
            }
            $l ~~ /'FileName="' $dir '/' $<sample>=[\w*\s]*/;
            if $<sample> {
                $sample = $<sample>.Str;
            }
            if ($note && $sample) {
                %note-map{$note}.push: $sample;
                $note = $sample = Any;
            }
        }

        for %note-map.keys>>.Int.sort -> $n {
            last if DEBUG && $n > 26;
            my $s = %note-map{~$n};
            if $s {
                say "$n\t: " ~ $s.reverse.join("\n\t{$n.chars xx ' ' if $++}:");
            }
        }
    }
}
