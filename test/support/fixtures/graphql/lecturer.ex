defmodule DesafioOinc.Fixtures.Graphql.Lecturer do
  defmacro __using__(_opts) do
    quote do
      def get_lecturer_query do
        """
        query($id: ID!) {
          getLecturer(id: $id) {
            id
            name
            age
          }
        }
        """
      end

      def list_lectuers_query do
        """
        query($only_deleted: Boolean) {
          listLecturers(only_deleted: $only_deleted) {
            id
            name
            age
          }
        }
        """
      end

      def create_lecturer_mutation do
        """
        mutation($name: String!, $age: Int!) {
          createLecturer(name: $name, age: $age) {
            id
            name
            age
          }
        }
        """
      end

      def update_lecturer_mutation do
        """
        mutation($id: ID!, $name: String, $age: Int) {
          updateLecturer(id: $id, name: $name, age: $age) {
            id
            name
            age
          }
        }
        """
      end

      def delete_lecturer_mutation do
        """
        mutation($id: ID!) {
          deleteLecturer(id: $id) {
            message
          }
        }
        """
      end

      def restore_lecturer_mutation do
        """
        mutation($id: ID!) {
          restoreLecturer(id: $id) {
            message
          }
        }
        """
      end
    end
  end
end
