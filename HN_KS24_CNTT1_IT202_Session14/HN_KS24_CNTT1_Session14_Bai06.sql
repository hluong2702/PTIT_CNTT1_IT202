USE social_network;

alter table users add column friends_count int default 0;

CREATE TABLE IF NOT EXISTS friend_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    from_user_id INT,
    to_user_id INT,
    status ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (from_user_id)
        REFERENCES users (user_id),
    FOREIGN KEY (to_user_id)
        REFERENCES users (user_id)
);

CREATE TABLE IF NOT EXISTS friends (
    user_id INT,
    friend_id INT,
    PRIMARY KEY (user_id , friend_id),
    FOREIGN KEY (user_id)
        REFERENCES users (user_id),
    FOREIGN KEY (friend_id)
        REFERENCES users (user_id)
);

insert into users (username) values ('nguyen_van_a'), ('le_thi_b');
insert into friend_requests (from_user_id, to_user_id) values (1, 2);

delimiter //

create procedure sp_accept_friend_request(
    in p_request_id int,
    in p_to_user_id int
)
begin
    declare v_from_user_id int;
    declare v_status varchar(20);

    declare exit handler for sqlexception
    begin
        rollback;
        select 'lỗi: không thể chấp nhận kết bạn. dữ liệu đã được hoàn tác.' as thông_báo;
    end;

    set transaction isolation level repeatable read;

    start transaction;

    
    select from_user_id, status into v_from_user_id, v_status 
    from friend_requests 
    where request_id = p_request_id and to_user_id = p_to_user_id 
    for update;

    if v_from_user_id is null or v_status != 'pending' then
        rollback;
        select 'lỗi: yêu cầu không tồn tại hoặc đã được xử lý trước đó' as thông_báo;
    else
        insert into friends (user_id, friend_id) values (v_from_user_id, p_to_user_id);
        insert into friends (user_id, friend_id) values (p_to_user_id, v_from_user_id);

        update users set friends_count = friends_count + 1 where user_id = v_from_user_id;
        update users set friends_count = friends_count + 1 where user_id = p_to_user_id;

        update friend_requests set status = 'accepted' where request_id = p_request_id;

        commit;
        select 'chấp nhận kết bạn thành công!' as thông_báo;
    end if;

end //

delimiter ;

call sp_accept_friend_request(1, 2);

select * from friends;
select user_id, username, friends_count from users where user_id in (1, 2);
select * from friend_requests;
