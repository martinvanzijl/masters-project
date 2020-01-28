#!/usr/bin/gawk -f

function header()
{
    TABLE_NUMBER += 1;
    while(( getline line<"header.txt") > 0 ) {
        gsub(/<RPS>/, rps, line);
        print line;
    }
    close("header.txt");
}

function footer()
{
    while(( getline line<"footer.txt") > 0 ) {
        gsub(/NUMBER/, TABLE_NUMBER, line);
        print line;
    }
    close("footer.txt");
}

BEGIN {
    rps_previous = 0;
}

{
    rps = $1;
    if (rps != rps_previous)
    {
        if (rps_previous > 0)
        {
            footer();
            print "\n\n";
        }
        header();
    }

    gsub(/TRUE/, "Yes");
    gsub(/True/, "Yes");
    gsub(/true/, "Yes");
    gsub(/FALSE/, "No");
    gsub(/False/, "No");
    gsub(/false/, "No");

    rps_previous = rps;

    print;
}

END {
    footer();
}
