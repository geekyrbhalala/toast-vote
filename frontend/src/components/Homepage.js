const Home = () => {
    return (
      <div>
        <h2>Welcome to the Toastmasters Voting System</h2>
        <p>Please select a category to vote or comment on.</p>
        <nav>
          <ul>
            <li><Link to="/vote/speaker">Vote for Best Speaker</Link></li>
            <li><Link to="/vote/evaluator">Vote for Best Evaluator</Link></li>
            <li><Link to="/vote/ttm">Vote for Best Table Topic Master</Link></li>
            <li><Link to="/comment/speaker">Comment on Best Speaker</Link></li>
          </ul>
        </nav>
      </div>
    );
  };
  