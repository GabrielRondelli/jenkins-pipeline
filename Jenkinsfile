#!groovy

currentBuild.result = "SUCCESS"
workspace = pwd() 
try {
	node {
		stage('Deploy') {
			ansiblePlaybook( 
				playbook: '${workspace}/lamp-simple/site.yml',
				inventory: '${workspace}/lamp-simple/hosts'
			)
		}
		stage('Test'){
			sh 'run_rake_tests.sh'
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
