package VBoxAdm::Model::DMARCReport;

use Moose;
use namespace::autoclean;

use Carp;

use VWebAdm::DB;
use VWebAdm::Utils;

extends 'VWebAdm::Model';

sub _init_fields {
    return [qw(id tsfrom tsto domain org reportid)];
}

sub create {
    my ( $self, $report_id, $from, $to, $domain, $org ) = @_;

    # Authorization - No access for regular users
    if ( !$self->user->is_admin() ) {
        $self->msg->push( 'error', 'Sorry. No access for regular users.' );
        return;
    }
    
    my $sql = 'SELECT COUNT(*) FROM dmarc_reports WHERE org = ? AND reportid = ?';
    my $sth = $self->dbh()->prepare($sql);
    
    if(!$sth) {
        $self->logger()->log( message => 'Failed to prepare SQL '.$sql.' w/ error: '.$self->dbh()->errstr(), level => 'error', );
        return;
    }
    
    $sth->execute($org, $report_id);
    
    my $count = $sth->fetchrow_array();
    
    if($count > 0) {
        $self->logger()->log( message => 'Report '.$report_id.' from '.$org.' already known.', level => 'debug', );
        return 0; # return 0 to indicated that this report already exists
    }

    $sql = 'INSERT INTO dmarc_reports (tsfrom,tsto,domain,org,reportid) VALUES(?,?,?,?,?)';
    $sth = $self->dbh()->prepare($sql);
    
    if(!$sth) {
        $self->logger()->log( message => 'Failed to prepare SQL '.$sql.' w/ error: '.$self->dbh()->errstr(), level => 'error', );
        return;
    }
    
    $sth->execute($from,$to,$domain,$org,$report_id);
    
    my $id = $self->dbh()->last_insert_id(undef, undef, undef, undef);
    
    $sth->finish();

    return $id;
}

sub get_id {
    my ( $self, $report_id, $org ) = @_;

    # Authorization - No access for regular users
    if ( !$self->user->is_admin() ) {
        $self->msg->push( 'error', 'Sorry. No access for regular users.' );
        return;
    }

    my $sql = "SELECT id FROM dmarc_reports WHERE reportid = ? AND org = ?";
    my $sth = &VWebAdm::DB::prepexec( $self->dbh, $sql, $report_id, $org );
    my $id  = $sth->fetchrow_array();

    if ( !$sth ) {
        $self->logger()->log( message => 'Could not execute query ' . $sql . ' due to error: ' . $self->dbh()->errstr, level => 'error', );
        $self->msg->push( 'error', 'Database error.' );
        return;
    }

    $sth->finish();

    return $id;
}

sub update {
    my ( $self ) = @_;
    
    # No need to update those after creation

    return;
}

sub delete {
    my ( $self, $entry_id ) = @_;

    # Authorization - No access for regular users
    if ( !$self->user->is_siteadmin() ) {
        $self->msg->push( 'error', 'Sorry. No access for regular users.' );
        return;
    }

    # delete role account
    if ( $entry_id && $entry_id =~ m/^\d+$/ ) {
        my $query = 'DELETE FROM dmarc_records WHERE report_id = ?';
        
        if ( my $sth = $self->dbh->prepare($query) ) {
            if ( $sth->execute($entry_id) ) {
                $sth->finish();
            }
        }
        
        $query = "DELETE FROM dmarc_reports WHERE id = ?";
        if ( my $sth = $self->dbh->prepare($query) ) {
            if ( $sth->execute($entry_id) ) {
                $sth->finish();
                $self->msg->push( 'information', "Deleted entry [_1].", $entry_id );
                return 1;
            }
            else {
                $self->logger()->log( message => 'Could not execute query ' . $query . ' due to error: ' . $self->dbh()->errstr, level => 'error', );
                return;
            }
        }
        else {
            $self->logger()->log( message => 'Could not prepare query ' . $query . ' due to error: ' . $self->dbh()->errstr, level => 'error', );
            $self->msg->push( 'error', "Unable to delete RoleAccount $entry_id. Database Error." );
            return;
        }
    }

    return;
}

sub read {
    my ( $self, $id ) = @_;

    # Authorization - No access for regular users
    if ( !$self->user->is_admin() ) {
        $self->msg->push( 'error', 'Sorry. No access for regular users.' );
        return;
    }

    return $self->_read( 'dmarc_reports', $id );
}

sub list {
    my ( $self, $params ) = @_;

    # Authorization - No access for regular users
    if ( !$self->user->is_admin() ) {
        $self->msg->push( 'error', 'Sorry. No access for regular users.' );
        return;
    }

    return $self->_list( 'dmarc_reports', $params );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

VBoxAdm::Model::AWL - Class for AWL

=cut
