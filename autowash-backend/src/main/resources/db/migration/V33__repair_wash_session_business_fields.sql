ALTER TABLE wash_sessions
    ADD COLUMN IF NOT EXISTS cancel_fault_type VARCHAR(20);

ALTER TABLE wash_sessions
    ADD COLUMN IF NOT EXISTS fee_amount BIGINT;

ALTER TABLE wash_sessions
    ADD COLUMN IF NOT EXISTS projected_points INT;

ALTER TABLE wash_sessions
    ADD COLUMN IF NOT EXISTS awarded_points INT;

ALTER TABLE wash_sessions
    ADD COLUMN IF NOT EXISTS checked_in_at TIMESTAMP WITH TIME ZONE;

ALTER TABLE wash_sessions
    ADD COLUMN IF NOT EXISTS started_at TIMESTAMP WITH TIME ZONE;

ALTER TABLE wash_sessions
    ADD COLUMN IF NOT EXISTS completed_at TIMESTAMP WITH TIME ZONE;

ALTER TABLE wash_sessions
    ADD COLUMN IF NOT EXISTS cancelled_at TIMESTAMP WITH TIME ZONE;

ALTER TABLE wash_sessions
    ADD COLUMN IF NOT EXISTS cancel_reason VARCHAR(500);

ALTER TABLE wash_sessions
    ADD COLUMN IF NOT EXISTS notes TEXT;

ALTER TABLE wash_sessions
    DROP CONSTRAINT IF EXISTS wash_sessions_fee_amount_check;

ALTER TABLE wash_sessions
    ADD CONSTRAINT wash_sessions_fee_amount_check
    CHECK (fee_amount IS NULL OR fee_amount >= 0);

ALTER TABLE wash_sessions
    DROP CONSTRAINT IF EXISTS wash_sessions_projected_points_check;

ALTER TABLE wash_sessions
    ADD CONSTRAINT wash_sessions_projected_points_check
    CHECK (projected_points IS NULL OR projected_points >= 0);

ALTER TABLE wash_sessions
    DROP CONSTRAINT IF EXISTS wash_sessions_awarded_points_check;

ALTER TABLE wash_sessions
    ADD CONSTRAINT wash_sessions_awarded_points_check
    CHECK (awarded_points IS NULL OR awarded_points >= 0);
