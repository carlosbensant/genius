const React = require('react');
const hashHistory = require('react-router').hashHistory;
const SessionStore = require('../../stores/session_store');
const SessionActions = require('../../actions/session_actions');
const HeaderUserProfile = require('./header_user_profile');
const HeaderAuth = require('./header_auth');

const Header = React.createClass({
  getInitialState() {
    return {
      currentUser: SessionStore.currentUser()
    };
  },

  componentDidMount(){
    this.sessionListener = SessionStore.addListener(this._sessionChange);
  },

  _sessionChange(){
    this.setState({ currentUser: SessionStore.currentUser() });
  },

  goHome(){
    window.location = "/";
  },

  handleLogout(e){
    e.preventDefault();
    SessionActions.logout();
  },

  render(){
    let authOrProfile;
    if (this.state.currentUser.email) {
      authOrProfile = <HeaderUserProfile
                currentUser={this.state.currentUser}
                handleLogout={this.handleLogout} />;
    } else {
      authOrProfile = <HeaderAuth />;
    }

    return(
      <header className="header clearfix">
        <section className="logo-container" onClick={this.goHome}>
          <a className="logo-link">"GENIUS"</a>
        </section>
        {authOrProfile}
      </header>
    );
  }
});

module.exports = Header;