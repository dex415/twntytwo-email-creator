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

## Product image sizing — Shopify CDN behaviour (measured)

On `/files/` URLs the Shopify CDN **ignores** `crop=center` and the legacy
`_1200x1200_crop_center` filename form. Asking for 1200x1200 returns 1200x1097 —
it only honours `width`.

It DOES honour `pad_color`, which returns the exact box requested and letterboxes
the remainder. So **Match all image shapes** appends
`&width=1200&height=1200&pad_color=<hex>`. Every product then renders identically
sized, and nothing is cropped off. Set the pad colour to match the image
background (`ffffff` for shots on white) and the padding is invisible.

Each product also has a **Size** slider (50-100%) that only shrinks — email
clients don't support the CSS needed to zoom in.

## Saved templates

Browser localStorage by default. Run `supabase-schema.sql` on the TWNTY-TWO
Supabase project and paste the URL + anon key into Settings. Never hardcode keys
into index.html — this repo is public.
