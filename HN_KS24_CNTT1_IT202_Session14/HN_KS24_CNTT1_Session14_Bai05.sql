USE social_network;

create table if not exists delete_log (
    log_id int primary key auto_increment,
    post_id int,
    deleted_by int,
    deleted_at datetime default current_timestamp
);

delimiter //

create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare v_post_exists int default 0;

    declare exit handler for sqlexception
    begin
        rollback;
        select 'lỗi hệ thống: không thể xóa bài viết. dữ liệu đã được hoàn tác.' as thông_báo;
    end;

    start transaction;

    select count(*) into v_post_exists 
    from posts 
    where post_id = p_post_id and user_id = p_user_id;

    if v_post_exists = 0 then
        rollback;
        select 'lỗi: bài viết không tồn tại hoặc bạn không có quyền xóa bài này' as thông_báo;
    else
        delete from likes where post_id = p_post_id;
        delete from comments where post_id = p_post_id;
        
        delete from posts where post_id = p_post_id;

        update users 
        set posts_count = posts_count - 1 
        where user_id = p_user_id;

        insert into delete_log (post_id, deleted_by) 
        values (p_post_id, p_user_id);

        commit;
        select 'xóa bài viết thành công!' as thông_báo;
    end if;

end //

delimiter ;

select * from users where user_id = 1;
select * from posts where post_id = 1;

call sp_delete_post(1, 1);

select * from users where user_id = 1;
select * from posts where post_id = 1;
select * from delete_log;

call sp_delete_post(2, 2); 
