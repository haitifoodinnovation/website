# Haiti Food Innovation ET - Website

Static website, ready for GitHub Pages. English + Amharic (/am/).

## Structure
- index/about/products/research/quality/contact/privacy/thanks/404 .html - English pages
- am/ - Amharic versions of every page (language toggle in the header)
- assets/ - stylesheet, script, logo (logo.svg) and product photos
- sitemap.xml, robots.txt - SEO files (domain is set to haitifoodinnovationet.com)

## Deploy on GitHub Pages (summary)
1. Create a GitHub account owned by the company, then a new PUBLIC repository (any name, e.g. `website`).
2. Upload ALL files and folders from this ZIP to the repository root.
3. Repository Settings → Pages → Source: "Deploy from a branch" → Branch: main, folder: / (root) → Save.
4. The site goes live at https://USERNAME.github.io/REPO/ within a few minutes. Review it.
5. Buy the domain at Namecheap (haitifoodinnovationet.com, or backup haitifoodinnovationethiopia.com).
6. Namecheap → Domain → Advanced DNS: add four A records for host `@` pointing to
   185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153
   and one CNAME record host `www` → USERNAME.github.io
7. GitHub → Settings → Pages → Custom domain: enter the domain, save, and tick "Enforce HTTPS" once available.

## Activate the forms (one-time)
The inquiry and review forms deliver to haitifoodinnovationET@gmail.com via FormSubmit.
After the site is live, submit each form once yourself; FormSubmit sends a confirmation
email to that inbox - click "Activate" and all future submissions will arrive by email.

## Before launch - confirm
- Phone numbers shown on the Contact page and footer (+251 926 972 523, +251 911 268 229).
- If the domain spelling differs, update DOMAIN in sitemap.xml/robots.txt (search & replace).
- Replace assets/img/logo.svg with the official logo file if preferred (keep the name logo.svg).
