Gazelle is a little script that recursively searches through a directory and creates a .gz file for every .html, .css and .js file it finds.

This is (only) useful if you want to compress transfers via website hosting that allows you to create Apache rewrites (using a .htaccess file) but doesn't allow you to enable mod_deflate or mod_gzip (usually for CPU reasons).

Usage `gazelle [--clear] DIRECTORY`