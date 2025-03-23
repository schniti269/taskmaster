defmodule TaskmasterWeb.BigTaskControllerTest do
  use TaskmasterWeb.ConnCase

  import Taskmaster.TasksFixtures

  @create_attrs %{description: "some description", title: "some title", duedate: ~U[2025-03-22 01:08:00Z]}
  @update_attrs %{description: "some updated description", title: "some updated title", duedate: ~U[2025-03-23 01:08:00Z]}
  @invalid_attrs %{description: nil, title: nil, duedate: nil}

  describe "index" do
    test "lists all big_tasks", %{conn: conn} do
      conn = get(conn, ~p"/big_tasks")
      assert html_response(conn, 200) =~ "Listing Big tasks"
    end
  end

  describe "new big_task" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/big_tasks/new")
      assert html_response(conn, 200) =~ "New Big task"
    end
  end

  describe "create big_task" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/big_tasks", big_task: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/big_tasks/#{id}"

      conn = get(conn, ~p"/big_tasks/#{id}")
      assert html_response(conn, 200) =~ "Big task #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/big_tasks", big_task: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Big task"
    end
  end

  describe "edit big_task" do
    setup [:create_big_task]

    test "renders form for editing chosen big_task", %{conn: conn, big_task: big_task} do
      conn = get(conn, ~p"/big_tasks/#{big_task}/edit")
      assert html_response(conn, 200) =~ "Edit Big task"
    end
  end

  describe "update big_task" do
    setup [:create_big_task]

    test "redirects when data is valid", %{conn: conn, big_task: big_task} do
      conn = put(conn, ~p"/big_tasks/#{big_task}", big_task: @update_attrs)
      assert redirected_to(conn) == ~p"/big_tasks/#{big_task}"

      conn = get(conn, ~p"/big_tasks/#{big_task}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, big_task: big_task} do
      conn = put(conn, ~p"/big_tasks/#{big_task}", big_task: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Big task"
    end
  end

  describe "delete big_task" do
    setup [:create_big_task]

    test "deletes chosen big_task", %{conn: conn, big_task: big_task} do
      conn = delete(conn, ~p"/big_tasks/#{big_task}")
      assert redirected_to(conn) == ~p"/big_tasks"

      assert_error_sent 404, fn ->
        get(conn, ~p"/big_tasks/#{big_task}")
      end
    end
  end

  defp create_big_task(_) do
    big_task = big_task_fixture()
    %{big_task: big_task}
  end
end
