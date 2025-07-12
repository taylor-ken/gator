-- name: CreateFeed :one
INSERT INTO feeds (id, created_at, updated_at, name, url, user_id)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *;

-- name: FetchFeed :many
SELECT f.name AS feed_name, f.url AS feed_url, u.name AS user_name
FROM feeds f
JOIN users u ON f.user_id = u.id;

-- name: CreateFeedFollow :one
WITH inserted_feed_follow AS (
    INSERT INTO feed_follows (id, created_at, updated_at, user_id, feed_id)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5
)
RETURNING *
)
SELECT
    i.*,
    f.name AS feed_name,
    u.name AS user_name
FROM inserted_feed_follow i
INNER JOIN feeds f ON i.feed_id = f.id
INNER JOIN users u ON i.user_id = u.id;

-- name: GetFeedFollowsForUser :many
SELECT ff.id AS feed_follow_id, ff.created_at, f.name AS feed_name, u.name AS user_name
FROM feed_follows ff
INNER JOIN feeds f ON ff.feed_id = f.id
INNER JOIN users u ON ff.user_id = u.id
WHERE ff.user_id = $1;

-- name: GetFeedByURL :one
SELECT * FROM feeds WHERE url = $1;
