defmodule DesafioOinc.Fixtures.Graphql.Student do
  defmacro __using__(_opts) do
    quote do
      def get_student_query do
        """
        query($id: ID!) {
          getStudent(id: $id) {
            id
            name
            age
          }
        }
        """
      end

      def list_students_query do
        """
        query($only_deleted: Boolean) {
          listStudents(only_deleted: $only_deleted) {
            id
            name
            age
          }
        }
        """
      end

      def create_student_mutation do
        """
        mutation($name: String!, $age: Int!) {
          createStudent(name: $name, age: $age) {
            id
            name
            age
          }
        }
        """
      end

      def update_student_mutation do
        """
        mutation($id: ID!, $name: String, $age: Int) {
          updateStudent(id: $id, name: $name, age: $age) {
            id
            name
            age
          }
        }
        """
      end

      def delete_student_mutation do
        """
        mutation($id: ID!) {
          deleteStudent(id: $id) {
            message
          }
        }
        """
      end

      def restore_student_mutation do
        """
        mutation($id: ID!) {
          restoreStudent(id: $id) {
            message
          }
        }
        """
      end
    end
  end
end
