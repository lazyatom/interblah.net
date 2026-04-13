Demo data in a JSON file
========================

One of the less glamorous but genuinely important parts of building
[Jelly](https://letsjelly.com) has been figuring out how to *show* people what
it does.

Jelly is a shared email tool for teams. That sounds simple enough, but when
someone visits the site and thinks "would this work for *my* team?", they need
to see something that looks like *their* kind of work. A veterinary clinic has
different needs to a creative agency. A neighbourhood events committee doesn't
look like a motorhome dealership. If every demo looks like "My Test Team" with
lorem ipsum emails, you're asking people to do all the imaginative work
themselves.

So I built a system to generate realistic demo teams, and I use it every
single day.

<!-- excerpt -->

## The shape of a team

Each demo team is a JSON file. Here's the rough structure:

{code team_structure, json}

Team members with realistic names, roles, and signatures. External contacts
who feel like real customers or partners. Shared email addresses that match
the kind of organisation. And then: conversations.

## Conversations tell the story

The conversations array is where it gets interesting. Each conversation is a
sequence of *events* -- incoming emails, outgoing replies, internal comments,
assignments, labels being applied, conversations being archived. A
conversation might look like this:

{code conversation_example, json}

The `@` mentions in comments get converted into proper mentions between members
of the team. 

You’ll notice all the timestamps in there are from 2025, but that doesn’t
matter; dates get automatically shifted by a consistent amount so the most
recent activity is always yesterday -- the conversations feel *current* rather
than frozen in time.

## Spinning up a niche

Running `bin/setup-demo.rb vet-clinic` creates a complete team
with all its members, addresses, labels, and a full history of conversations.
All the activity logging, the assignments, the internal notes -- it all
happens through the same code paths that real usage would take.

I've got demo teams for a vet clinic, a creative agency, a motorhome
dealership, a neighbourhood events committee, and a few others. Each one
embodies a particular niche, with industry-appropriate language, roles, and
workflows. When I want to show Jelly to someone who runs a small non-profit,
I can pull up the neighbourhood events team and they can see *their kind of
work* reflected back at them.

## *LL*et *M*e build more

Because I have a standardised, standalone, easy to parse format for these demo teams, if I need to create a new set of demo team data,  I don’t have to painstakingly[^bluth] create every new user, contact and conversation by hand; I can pass it over to a tool that’s *particularly* well suited to stochaistically parroting out a big long string that’s similar to what it’s seem before: generative “AI”. 

I can give Claude a copy of one of these files with the prompt “build me a demo data file using this format for a team who does ...” -- whatever, really -- and in a few minutes I have a fully working team in Jelly that I can show to prospective users that they can immediately relate to.

## Works great for development too

I don’t generate new teams everyday, but I _do_ use this demo data every day. I’ve created essentially a huge suite of records perfectly suited for click-testing and exploring changes without needing to touch production to feel realistic.

And I’ve built one final bonus that _really_ helps me locally:

1. a comand to rebuild me a clean database with every single demo team instantiated into real model data in the database
2. a pair of commands to 
   - produce a dump file of the development data, and 
   - restore the development data from that dump.

This means I can do a whole bunch of development, run migrations, alter the schema, edit conversations, and then when I want to get the database[^inboxtopus] back to a clean state, simply wipe clean and reload the dump. 

{code database_rake, ruby}

It’s _way_ faster than loading a seed file and having to re-run all of the logic to actually create this data.

[^bluth]: The first set of demo data we created actually _was_ written by hand, more like a typical seed file. We all imagined a bunch of email conversations that might’ve taken place in the [Bluth Company](https://en.wikipedia.org/wiki/Arrested_Development). But it turns out that showing conversations from a disfunctional business (and family), while very funny, isn’t necessarily the best way to “sell” a productivity product 😉. That team does live on though -- the data has since been translated into JSON, and lives alongside the others.
[^inboxtopus]: Jelly’s _codename_ was “inboxtopus” 

:kind: blog
:created_at: 2026-04-13 12:00:00 +0100
:updated_at: 2026-04-13 12:00:00 +0100
:team_structure: |
  {
    "name": "Acme Tools",
    "account_addresses": [
      { "name": "Sales", "email_address": "sales@acmetools.test" },
      { "name": "Support", "email_address": "support@acmetools.test" }
    ],
    "team_members": [
      {
        "name": "Sarah Chen",
        "email": "sarah@acmetools.test",
        "signature": "Sarah Chen<br><em>Sales Manager</em>"
      }
    ],
    "contacts": {
      "customer@constructionclient.com": { "name": "Pat Rivera" }
    },
    "conversations": []
  }
:conversation_example: |
  {
    "account_address": "sales@acmetools.test",
    "subject": "Bulk order inquiry - rubber hammers",
    "events": [
      {
        "type": "message",
        "direction": "incoming",
        "from": "pat@riverahardware.test",
        "date": "2025-01-26 09:00:00",
        "body": "<p>Hi, we're interested in placing a bulk order...</p>"
      },
      {
        "type": "assignment",
        "assigned_to": "sarah@acmetools.test",
        "date": "2025-01-26 09:15:00"
      },
      {
        "type": "comment",
        "by": "sarah@acmetools.test",
        "body": "I'll handle this — @mike@acmetools.test can you check stock?",
        "date": "2025-01-26 09:20:00"
      }
    ]
  }
:database_rake: |
  if Rails.env.development?
    task "db:dump" do
      sh "pg_dump -Fc -v --no-owner --no-acl inboxtopus_development > tmp/dump.pdump"
      puts "Database dumped"
    end
  
    task "db:restore" do
      sh "touch tmp/restart.txt" # close any open connections to the database
      sh "rails db:drop db:create" # get a clean database
      sh "pg_restore -v --no-owner --no-acl -d inboxtopus_development tmp/dump.pdump"
      puts "Database restored"
    end
  end
