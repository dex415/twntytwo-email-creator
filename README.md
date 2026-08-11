# TWNTY-TWO® Email Creator

Marketing email bodies in the TWNTY-TWO transactional style, for pasting into
**Shopify Messaging → Add section → Custom → Custom Liquid**. Shopify renders the
logo band above and the unsubscribe footer below; this tool builds the middle.

## Critical layout note

The card table carries `width:100%; max-width:520px; margin:0 auto`. The
`margin:0 auto` is load-bearing — a width:100% table with a max-width is a block
box and `<td align="center">` does NOT centre it. Without it Shopify renders the
card flush left. Card padding lives on a `<td>`, never on the width:100% table.

## What does and doesn't export

Subject and preheader are stored with the template but never appear in the
Liquid — Custom Liquid cannot set them. Copy them into Shopify's Email details
panel by hand (there are Copy buttons next to each).

## Product image sizing

Each product in a Product Grid has a **Size** slider (50–100%). It only shrinks —
email clients don't support the CSS needed to zoom in. Shrink the item shot too
close until it matches its neighbour. The image area stays a fixed 218px tall at
any scale so names and prices stay aligned. For a real tighter crop, append
`&width=800&height=800&crop=center` to a Shopify CDN image URL.

## Saved templates

Browser localStorage by default. Run `supabase-schema.sql` on the TWNTY-TWO
Supabase project and paste the URL + anon key into Settings. Never hardcode keys
into index.html — this repo is public.
