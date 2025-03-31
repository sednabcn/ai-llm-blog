#!/bin/bash

# Define colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Script to reverse file moves and restore original file structure
echo -e "${GREEN}Starting file recovery process...${NC}"

# Count total files to process
TOTAL_FILES=$(grep -c "^- " "$0")
echo -e "${YELLOW}Found $TOTAL_FILES files to recover${NC}"

# Counter for progress tracking
COUNTER=0
SUCCESS=0
FAILED=0

# Extract file moves from this script itself
while IFS= read -r line; do
  if [[ $line =~ ^-\ +([^\ ]+)\ +-\>\ +([^\ ]+) ]]; then
#  if [[ $line =~ ^-\ (.*)\ ->\ (.*) ]]; then
    ((COUNTER++))
    
    # Extract source and destination paths
    src="${BASH_REMATCH[2]}"
    dest="${BASH_REMATCH[1]}"
    
    # Show progress
    echo -e "${YELLOW}[$COUNTER/$TOTAL_FILES] Processing:${NC} $src -> $dest"
    
    # Create directory structure if it doesn't exist
    dest_dir="$(dirname "$dest")"
    if [ ! -d "$dest_dir" ]; then
      mkdir -p "$dest_dir"
      echo -e "  Creating directory: $dest_dir"
    fi
    
    # Check if source file exists
    if [ ! -f "$src" ]; then
      echo -e "  ${RED}Error:${NC} Source file doesn't exist: $src"
      ((FAILED++))
      continue
    fi
    
    # Move the file back to its original location
    if mv "$src" "$dest" 2>/dev/null; then
      echo -e "  ${GREEN}Success:${NC} File restored"
      ((SUCCESS++))
    else
      echo -e "  ${RED}Failed:${NC} Couldn't move file to $dest"
      ((FAILED++))
    fi
  fi
done < "$0"

# Summary
echo -e "\n${GREEN}File recovery completed!${NC}"
echo -e "${GREEN}Successfully recovered:${NC} $SUCCESS files"
if [ $FAILED -gt 0 ]; then
  echo -e "${RED}Failed to recover:${NC} $FAILED files"
fi

exit 0

# File mapping data follows
- /home/agagora/Downloads/GITHUB/ai-llm-blog/Gemfile.remote.copy -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/Gemfile.remote.copy
- /home/agagora/Downloads/GITHUB/ai-llm-blog/Gemfile.remote.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/Gemfile.remote.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/assets/css/bakcss.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/bakcss.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/assets/css/main.scssX -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/main.scssX
- /home/agagora/Downloads/GITHUB/ai-llm-blog/assets/css/main.scss1014-29-03-25 -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/main.scss1014-29-03-25
- /home/agagora/Downloads/GITHUB/ai-llm-blog/assets/css/main.scss2149280325 -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/main.scss2149280325
- /home/agagora/Downloads/GITHUB/ai-llm-blog/assets/css/main.scss2803252041 -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/main.scss2803252041
- /home/agagora/Downloads/GITHUB/ai-llm-blog/assets/css/main.scss2218-280325 -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/main.scss2218-280325
- /home/agagora/Downloads/GITHUB/ai-llm-blog/assets/css/main.scss280325 -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/main.scss280325
- /home/agagora/Downloads/GITHUB/ai-llm-blog/assets/css/main.scss2312-280325 -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/main.scss2312-280325
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/debase-ruby_core_source-3.4.1/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/fspath-3.1.2/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_1.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-feed-0.17.0/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_2.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/unicode-display_width-1.8.0/MIT-LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/MIT-LICENSE.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-gist-1.5.0/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_3.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-admin-0.12.0/lib/jekyll-admin/public/static/js/2.08ea13e0.chunk.js.LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/2.08ea13e0.chunk.js.LICENSE.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-swiss-1.0.0/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_4.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/uglifier-4.2.1/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_5.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim-0.31.4/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_6.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/webrick-1.9.1/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_7.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/json-minify-0.0.3/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_8.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_9.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/optipng.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/optipng.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/gifsicle.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/gifsicle.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/advancecomp.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/advancecomp.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/cexcept.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/cexcept.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/liblcms2.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/liblcms2.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/libjpeg-turbo.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/libjpeg-turbo.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/bmp2png.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/bmp2png.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/optipng-authors.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/optipng-authors.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/pngquant.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/pngquant.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/iqa.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/iqa.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/mozjpeg.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/mozjpeg.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/pngout.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/pngout.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/jpeg-archive.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/jpeg-archive.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/7z.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/7z.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/oxipng.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/oxipng.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/libpng.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/libpng.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/jpegoptim.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/jpegoptim.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/gifread.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/gifread.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/pngcrush.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/pngcrush.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/libjpeg-x86-simd.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/libjpeg-x86-simd.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/zopfli.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/zopfli.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/libjpeg.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/libjpeg.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/jhead.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/jhead.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/zopfli-contributors.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/zopfli-contributors.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/zlib.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/zlib.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/image_optim_pack-0.12.0.20250227-x86_64-linux/acknowledgements/smallfry.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/smallfry.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/github-pages-health-check-1.17.9/config/fastly-ips.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/fastly-ips.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/github-pages-health-check-1.17.9/config/cloudflare-ips.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/cloudflare-ips.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/pdf-reader-2.14.1/lib/pdf/reader/glyphlist.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/glyphlist.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/pdf-reader-2.14.1/lib/pdf/reader/glyphlist-zapfdingbats.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/glyphlist-zapfdingbats.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/pdf-reader-2.14.1/lib/pdf/reader/encodings/mac_roman.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/mac_roman.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/pdf-reader-2.14.1/lib/pdf/reader/encodings/mac_expert.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/mac_expert.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/pdf-reader-2.14.1/lib/pdf/reader/encodings/win_ansi.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/win_ansi.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/pdf-reader-2.14.1/lib/pdf/reader/encodings/zapf_dingbats.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/zapf_dingbats.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/pdf-reader-2.14.1/lib/pdf/reader/encodings/pdf_doc.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/pdf_doc.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/pdf-reader-2.14.1/lib/pdf/reader/encodings/symbol.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/symbol.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/pdf-reader-2.14.1/lib/pdf/reader/encodings/standard.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/standard.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/csv-3.3.3/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_10.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/public_suffix-6.0.1/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_11.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/public_suffix-6.0.1/data/list.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/list.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/minitest-5.25.5/Manifest.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/Manifest.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-seo-tag-2.8.0/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_12.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/safe_yaml-1.0.5/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_13.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/safe_yaml-1.0.5/spec/issue48.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/issue48.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-redirect-from-0.16.0/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_14.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/mini_portile2-2.8.8/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_15.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/mini_portile2-2.8.8/test/assets/test-cmake-1.0/CMakeLists.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/CMakeLists.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-sitemap-1.4.0/lib/robots.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/robots.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-sitemap-1.4.0/spec/robot-fixtures/static-at-source-root/robots.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/robots_1.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-sitemap-1.4.0/spec/robot-fixtures/permalinked-page-in-subdir/assets/robots.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/robots_2.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-sitemap-1.4.0/spec/robot-fixtures/static-in-subdir/assets/robots.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/robots_3.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-sitemap-1.4.0/spec/robot-fixtures/page-at-root/robots.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/robots_4.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/tty-which-0.4.2/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_16.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/rexml-3.4.1/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_17.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/public_suffix-4.0.7/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_18.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/public_suffix-4.0.7/data/list.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/list_1.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/public_suffix-4.0.7/test/tests.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/tests.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/in_threads-1.6.0/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_19.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/webrick-1.8.2/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_20.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/addressable-2.8.7/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_21.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/hashery-2.1.2/NOTICE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/NOTICE.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/hashery-2.1.2/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_22.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/dnsruby-1.72.4/demo/to_resolve.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/to_resolve.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/dnsruby-1.72.4/test/custom.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/custom.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/terminal-table-3.0.2/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_23.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-feed-0.15.1/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_24.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/concurrent-ruby-1.3.5/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_25.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/jekyll-avatar-0.7.0/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_26.txt
- /home/agagora/Downloads/GITHUB/ai-llm-blog/vendor/bundle/ruby/3.3.0/gems/sass-listen-4.0.0/LICENSE.txt -> /home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish/LICENSE_27.txt

