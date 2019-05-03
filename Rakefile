namespace "jenkins" do
  desc "Jenkins setup"
  task :setup do
    pdir = File.expand_path("..", Dir.pwd)
    cdir = Dir.pwd
    branch = ENV.fetch('branch', 'master')
    gremote = `git remote`

  if !gremote.empty?
    puts ""
    sh "git fetch"
    githead = `git rev-parse HEAD`
    gitlocalhead = `git rev-parse @{u}`
    if githead != gitlocalhead
      puts ""
      puts "Update detected, updating now"
      puts ""
      cmd1 = "git pull && "
      cmd1 += "rake jenkins:setup branch=#{branch}"
      sh cmd1
    else
      puts ""
      puts "Git repository is up to date"
      puts ""
    end
  else
    puts ""
    puts "Auto updating can be enabled by running 'rake jenkins:autoupdate'"
    puts ""
  end

    cmd2 = "rm -r -f #{pdir}/DockerJenkinsData && "
    cmd2 += "git clone --depth 1 --single-branch -b #{branch} https://github.com/mathwro/DockerJenkinsData.git #{pdir}/DockerJenkinsData/ && "
    cmd2 += "docker pull jenkins/jenkins && "
    cmd2 += "docker build -t mobilejenkins . "
    sh cmd2
    puts "Jenkins is now set up ready to run"
  end

  desc "Jenkins start"
  task :start do
    pdir = File.expand_path("..", Dir.pwd)
    port = ENV.fetch('port', '8081')
    dockerid = `docker ps | grep 'mobilejenkins' | awk '{ print $1 }'`.chomp
    sh "docker run -d -t -v #{pdir}/DockerJenkinsData/jenkins_home:/var/jenkins_home -v #{pdir}/DockerJenkinsData/scripts:/var/jenkins_home/scripts -v /var/run/docker.sock:/var/run/docker.sock -p #{port}:8080 -p 50000:50000 -p 2375:2375 mobilejenkins"
    puts "Docker image ID: #{dockerid}"
    while dockerid.to_s.empty?
    	dockerid = `docker ps | grep 'mobilejenkins' | awk '{ print $1 }'`.chomp
    	puts "Docker image ID: #{dockerid}"
      break if !dockerid.empty?
    end
    
    if File.exist?("$HOME/var/run/docker.sock")
      sh "docker exec -u root -it #{dockerid} chown jenkins /var/run/docker.sock"
    else
      sh "export DOCKER_HOST=localhost:2375"
    end

    sh "docker exec -u root -it #{dockerid} chown -R jenkins /usr/local/bin"
    sh "docker exec -u root -it #{dockerid} chown -R jenkins /var/lib/gems"
    sh "docker exec -u root -it #{dockerid} chown -R jenkins /usr/lib/ruby"
    puts ""
    puts "Username: jenkins"
    puts "Password: strongpw"
    puts "Jenkins is now running on port #{port}"
    puts ""
  end

  desc "Jenkins shutdown"
  task :stop do
    jenkinsid = `docker ps | grep 'mobilejenkins' | awk '{ print $1 }'`
    seleniumid = `docker ps | grep 'selenium' | awk '{ print $1 }'`
    
    if !jenkinsid.to_s.empty?
      sh "docker stop $(docker ps | grep 'mobilejenkins' | awk '{ print $1 }')"
    end

    if !seleniumid.to_s.empty?
      sh "docker stop $(docker ps | grep 'selenium' | awk '{ print $1 }')"
    end

    puts ""
    puts "Jenkins is now closed"
    puts ""
  end

  desc "Enable Jenkins autoupdate"
  task :autoupdate do
    gremote = `git remote`
    if gremote.empty? 
      cmd = "git remote add origin https://github.com/mathwro/DockerJenkinsScripts.git && "
      cmd += "git fetch && "
      cmd += "git branch --set-upstream-to=origin/master master"
      sh cmd
      puts ""
      puts "Auto update is now enabled"
    else
      puts "Auto update is already enabled"
    end
  end
end
