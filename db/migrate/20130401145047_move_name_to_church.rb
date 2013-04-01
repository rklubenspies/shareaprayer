class MoveNameToChurch < ActiveRecord::Migration
  def up
    add_column :churches, :name, :string
    execute "
      UPDATE churches
      SET name = p.name
      FROM (SELECT church_id, name FROM church_profiles) AS p
      WHERE churches.id=p.church_id;
    "
    remove_column :church_profiles, :name
  end

  def down
    add_column :church_profiles, :name, :string
    execute "
      UPDATE church_profiles
      SET name = c.name
      FROM (SELECT id, name FROM churches) AS c
      WHERE church_profiles.church_id=c.id;
    "
    remove_column :churches, :name
  end
end
