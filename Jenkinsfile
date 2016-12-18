#!groovy

currentBuild.result = "SUCCESS"
try {
	node {
		stage('Deploy') {
			ansiblePlaybook( 
				playbook: "lamp_simple/site.yml",
				inventory: "lamp_simple/hosts"
			)
		}
		stage('Test'){
			sh '/usr/local/rvm/rubies/ruby-2.3.0/bin/rake --rakefile ./spec/Rakefile --libdir ./spec/lib'
		}
	}
}catch (err) {
	currentBuild.result = "FAILURE"

            mail body: "project build error is here: ${env.BUILD_URL}" ,
            from: 'xxxx@yyyy.com',
            replyTo: 'yyyy@yyyy.com',
            subject: 'project build failed',
            to: 'zzzz@yyyyy.com'

	throw err
}
