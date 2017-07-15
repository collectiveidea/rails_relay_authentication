module Postgres
  class User
    module Read
      module ClassMethods
      
        def where(params)
          table.where(params)
        end

        def find_by(params)
          where(params).first
        end

        def find(id)
          find_by(id: id)
        end

        def get(uuid)
          find_by(uuid: Types::UUID[uuid]) if uuid.present?
        end

        def delete_all
          table.delete
        end

        def table
          Sequel::Model.db[:users]
        end
      end
      extend ClassMethods
    end
  end
end