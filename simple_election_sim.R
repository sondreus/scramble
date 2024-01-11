
res <- data.frame()
for(j in 1:100){

  # Simulate N voters with preferences on two dimensions
  N <- 1000
  dim_a <- rnorm(N)
  dim_b <- rnorm(N)
  
  # Generate 4 parties, two similar ones, one on their opposite, and one strange one
  a <- c(1, 1)
  b <- c(1.1, 0.9)
  c <- c(-1, -1)
  d <- c(-3, 0)
  
  # Get how voters feel about the different parties (abs distance in two-dimensional preference space)
  dist_a <- abs(dim_a-a[1]) + abs(dim_b -a[2])
  dist_b <- abs(dim_a-b[1]) + abs(dim_b -b[2])
  dist_c <- abs(dim_a-c[1]) + abs(dim_b -c[2])
  dist_d <- abs(dim_a-d[1]) + abs(dim_b -d[2])
  
  # Let voters vote for whoever they agree the most with
  voter_choice <- data.frame(dist_a, dist_b, dist_c, dist_d)
  for(i in 1:nrow(voter_choice)){
  voter_choice$choice[i] <- which.min(voter_choice[i, 1:4]) 
  }
  
  # Save the results:
  res <- rbind(res, table(voter_choice$choice))
  }

colnames(res) <- c('voted a', 'voted b', 'voted c', 'voted d')
res$voted_a_or_b <- res$`voted a` + res$`voted b` 
res <- res/N

cor(res)
