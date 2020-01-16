#!/usr/bin/gawk -f

function header()
{
    TABLE_NUMBER += 1;
    while(( getline line<"header.txt") > 0 ) {
        gsub(/NUMBER/, TABLE_NUMBER, line);
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
    header();
}

{
    LINE += 1;
    if (LINE == 40)
    {
        footer();
        print "\n\n";
        header();
        LINE = 1;
    }

    gsub(/TRUE/, "Yes");
    gsub(/True/, "Yes");
    gsub(/true/, "Yes");
    gsub(/FALSE/, "No");
    gsub(/False/, "No");
    gsub(/false/, "No");

    print;
}

END {
    footer();
}
