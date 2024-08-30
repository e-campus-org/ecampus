defmodule Backend.Repo.Migrations.LessonTopicChanges do
  use Ecto.Migration

  def up do
    execute("""
     alter table lesson_topics
      alter column content type jsonb using to_json(content),
      alter column content set default '{}';
    """)

    execute("""
     alter table lesson_topics drop column description;
    """)

    execute("""

     alter table lesson_topics drop column objectives;
    """)
  end

  def down do
    execute("""
     alter table lesson_topics
      alter column content drop default,
      alter column content type text using (content::text);
    """)

    execute("""
     alter table lesson_topics add column description text;
    """)

    execute("""
     alter table lesson_topics add column objectives text;
    """)
  end
end
