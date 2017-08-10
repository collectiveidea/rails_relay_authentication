Sequel.migration do
  up do
    run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'
    run File.open(Rails.root.join('sql', 'next_id.sql')) { |f| f.read }
  end

  down do
  end
end
