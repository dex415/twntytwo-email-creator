# TWNTY-TWO® Email Creator

Builds marketing email bodies in the TWNTY-TWO transactional style, for pasting
into **Shopify Messaging → Add section → Custom → Custom Liquid**.

Shopify renders the logo band above and the social/address/unsubscribe footer
below. This tool generates only the middle — campaign tag down to the 4-button
footer.

## Use

Open the deployed URL. Pick a starter (Drop / Sale / Blank), edit blocks, hit
**Copy Liquid**, paste into the Custom Liquid section.

In Shopify's **Email colors** panel set Content background and Border to
`#000000`, or the campaign shell frames the dark card in white.

## Develop

Single self-contained file. No build step, no dependencies. Edit `index.html`
directly, commit, push — Pages redeploys in about a minute.

## Saved templates

Defaults to browser localStorage (per-browser, per-origin). To share templates
across machines, run `supabase-schema.sql` on the TWNTY-TWO Supabase project and
paste the project URL + anon key into Settings.

Note: the anon key is stored in the visitor's own localStorage, never committed
to this repo. If this repo is public, keep it that way — do not hardcode keys.
