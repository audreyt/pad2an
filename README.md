# Hackpad to SayIt importer

1. Create a new instance at [mySociety SayIt](http://sayit.mysociety.org/instances/add), or use an existing instance.
2. Click **Import Speeches** to show the `/import/akomantoso` screen.
3. Enter the URL `http://pad.archive.tw/` followed by Hackpad source URL (with no spaces in-between) to import the section.

For example, for the original Hackpad URL at `https://hackpad.com/PTD3vnvhMjv` the corresponding import URL is `http://pad.archive.tw/https://hackpad.com/PTD3vnvhMjv` — you can view it in browser to preview the XML structure (cache updated every minute).

------

Transcript format:
> Speaker’s name on its own line, ending with a colon.
>
> Speech content follows the speaker’s name as indented text and/or bullet items.

(Parenthesised non-indented lines are nonverbal actions.)

------

**Heading 1** denotes sub-sections.

To adjust or delete existing sections, just re-import an Hackpad with the same title text (a different URL is OK) and select **Replace them** in the import screen.

## Usage

```
npm install -g livescript
npm install
lsc server.ls # or `heroku local`
```
